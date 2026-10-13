[![Gem Version](https://badge.fury.io/rb/rails_omnibar.svg)](http://badge.fury.io/rb/rails_omnibar)
[![Build Status](https://github.com/jaynetics/rails_omnibar/actions/workflows/tests.yml/badge.svg)](https://github.com/jaynetics/rails_omnibar/actions)

# RailsOmnibar

This adds an omnibar for power users to Ruby on Rails. The bar can appear as a permanent input field or a modal that pops up when you hit e.g. `⌘+K` or `Ctrl+K`. It can be used to quickly execute commands via a fuzzy search. Templates for many possible commands, like navigating to admin views or searching records, are built-in.

[Preview](https://github.com/user-attachments/assets/3c03a749-a522-4f9e-b8a2-c67903b0d5e2)

## Installation

Add `rails_omnibar` to your bundle and add the following line to your `config/routes.rb`:

```ruby
mount RailsOmnibar::Engine => '/rails_omnibar'
```

You can pick any path. See [Authorization](#authorization) for limiting access to the engine.

## Configuration

### Basic Usage

```ruby
# app/lib/omnibar.rb

Omnibar = RailsOmnibar.configure do |c|
  c.max_results = 5 # The number of fuzzy search results to show. Default: 10.

  # Render as a modal that is hidden by default and toggled with a hotkey.
  # The default value for this setting is false - i.e. render inline.
  c.modal = true # default is false

  # Use a custom hotkey to focus the omnibar (or toggle it if it is a modal).
  # CTRL+<hotkey> and CMD+<hotkey> will both work.
  c.hotkey = 't' # default is 'k'

  # Add static items that can be found by fuzzy typing.
  # "suggested" items will be displayed even before the user starts typing.
  c.add_item(title: 'Important link', url: 'https://www.disney.com', suggested: true)
  c.add_item(title: 'Important info', modal_html: '<b>You rock</b>')

  # If ActiveAdmin or RailsAdmin are present, call this method
  # to add all resource index routes as searchable items.
  # See the "Other options" section of this README on how to render
  # the omnibar within these admin UIs.
  c.add_webadmin_items

  # Add the index URLs of a custom backoffice as searchable items
  Rails.application.routes.routes.each do |route|
    next unless route.defaults[:action] == 'index'
    next unless name = route.name[/^backoffice_(.+)/, 1]

    # items can have icons:
    # arrows, cloud, cog, dev, document, home, question, search,
    # sparkle, user, wallet, x
    c.add_item(title: name.humanize, url: route.format({}), icon: :cog)
  end

  # Add commands
  # ------------

  # This command will allow searching users by id by typing e.g. 'u123'.
  # The capture group is used to extract the value for the DB query.
  c.add_record_search(
    pattern: /^u(\d+)/,
    example: 'u123',
    model:   User,
  )

  # Search records by column(s) other than id (via a LIKE query by default)
  c.add_record_search(
    pattern: /^u (.+)/,
    example: 'u Joe',
    model:   User,
    columns: %i[first_name last_name],
  )

  # The special #add_help method must be called last if you want a help entry.
  # It shows a modal with descriptions and examples of the commands, e.g.:
  #
  #   * Search User by id
  #     Example: `u123`
  #   * Search User by first_name OR last_name
  #     Example: `u Joe`
  #   * Search User by id
  #     Example: `U123`
  #   * Search Google
  #     Example: `g kittens`
  #   * Get count of a DB table
  #     Example: `COUNT users`
  #
  c.add_help
end
```

To use the onmibar, you need to render it somewhere. E.g. in `app/views/layouts/application.html.erb`:

```erb
<%= Omnibar.render(self) %>
```

If you are not rendering your frontend within rails, you can pass the `Omnibar.html_url` to your frontend, fetch the omnibar HTML from there, and inject it into your page.

### Authorization

You can limit access to commands (e.g. search commands) and items.

#### Option 1: globally limit engine access

```ruby
authenticate :user, ->(user){ user.superadmin? } do
  mount RailsOmnibar::Engine => '/rails_omnibar'
end
```

#### Option 2: use `RailsOmnibar::auth=`

This is useful for fine-grained authorization, e.g. if there is more than one omnibar or multiple permission levels.

```ruby
# the auth proc is executed in the controller context by default,
# but can also take the controller and omnibar as arguments
MyOmnibar.auth = ->{ user_signed_in? }
MyOmnibar.auth = ->(controller, omnibar:) do
  controller.user_signed_in? && omnibar.is_a?(NormalUserOmnibar)
end
```

#### Option 3: Item-level conditionality

Items and commands can have an `if` proc that is executed in the controller context. If it returns false, the item is not shown and the command can not be executed.

```ruby
MyOmnibar.add_item(
  title: 'Admin link',
  url:   admin_url,
  if:    ->{ current_user.admin? }
)
```

(By the way, this is the reason `self` needs to be passed when rendering the omnibar with `Omnibar.render(self)` – it provides the controller context in which methods like `current_user` can be evaluated.)

### Using multiple different omnibars

```ruby
BaseOmnibar = Class.new(RailsOmnibar).configure do |c|
  c.add_item(
    title: 'Log in',
    url:    Rails.application.routes.url_helpers.log_in_url
  )
end

UserOmnibar = Class.new(RailsOmnibar).configure do |c|
  c.auth = ->{ user_signed_in? }
  c.add_item(
    title: 'Log out',
    url:    Rails.application.routes.url_helpers.log_out_url
  )
end
```

Then, in some layout:

```erb
<%= (user_signed_in? ? UserOmnibar : BaseOmnibar).render(self) %>
```

Omnibars can also inherit commands, configuration, and items from existing omnibars:

```ruby
SuperuserOmnibar = Class.new(UserOmnibar).configure do |c|
  # add more items that only superusers should get
end
```

### Other options and usage patterns

#### Adding multiple items at once

```ruby
MyOmnibar.add_items(
  *MyRecord.all.map { |rec| { title: rec.title, url: url_for(rec) } }
)
```

##### Rendering the omnibar in ActiveAdmin v4

Run `rails g active_admin:views`. This will copy activeadmin's partials to your app so you can customize them. You only need to keep `views/layouts/active_admin.html.erb` for the omnibar. Edit it and add `MyOmnibar.render(self)` before `</body>`.

##### Rendering the omnibar in ActiveAdmin v3

```ruby
module AddOmnibar
  def build_page(...)
    within(super) { text_node(MyOmnibar.render(self)) }
  end
end
ActiveAdmin::Views::Pages::Base.prepend(AddOmnibar)
```

##### Rendering the omnibar in RailsAdmin

Add `MyOmnibar.render(self)` to `app/views/layouts/rails_admin/application.*`.

#### Adding all index routes as searchable items

```ruby
Rails.application.routes.routes.each do |route|
  next unless route.defaults.values_at(:action, :format) == ['index', nil]
  MyOmnibar.add_item(title: route.name.humanize, url: route.format({}))
end
```

#### Custom record lookup and rendering

```ruby
MyOmnibar.add_record_search(
  pattern:  /^U(\d+)/,
  example:  'U123',
  model:    User,
  finder:   ->(id) { User.find_by(admin: true, id: id) },
  itemizer: ->(user) do
    { title: "Admin #{user.name}", url: admin_url(user), icon: :user }
  end
)
```

#### Custom search, plus mapping to multiple results

```ruby
MyOmnibar.add_search(
  description: 'Google',
  pattern:     /^g (.+)/,
  example:     'g kittens',
  # omnibar: and controller: keyword args are provided to command procs
  finder:      ->(value, omnibar:) do
    Google.search(value, limit: omnibar.max_results)
  end,
  itemizer:    ->(res) do
    [
      { title: res.title, url: res.url },
      { title: "#{res.title} @archive", url: "web.archive.org/web/#{res.url}" }
    ]
  end,
)
```

#### Completely custom command

```ruby
MyOmnibar.add_command(
  description: 'Get count of a DB table',
  pattern:     /COUNT (.+)/i,
  example:     'COUNT users',
  resolver:    ->(value, controller:) do
    if controller.current_user.client?
      { title: (value.classify.constantize.count * 2).to_s }
    else
      { title: value.classify.constantize.count.to_s }
    end
  rescue => e
    { title: e.message }
  end,
)
```

## Development

### Setup

* Clone the repository
* Go into the directory
* Run `bin/setup` to install Ruby and JS dependencies
* `bundle exec rake` prepares and runs all tests

## License

This program is provided under an MIT open source license, read the [LICENSE.txt](https://github.com/jaynetics/rails_omnibar/blob/master/LICENSE.txt) file for details.
