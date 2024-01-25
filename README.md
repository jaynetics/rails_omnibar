[![Gem Version](https://badge.fury.io/rb/rails_omnibar.svg)](http://badge.fury.io/rb/rails_omnibar)
[![Build Status](https://github.com/jaynetics/rails_omnibar/actions/workflows/tests.yml/badge.svg)](https://github.com/jaynetics/rails_omnibar/actions)

# RailsOmnibar

Add an Omnibar to Ruby on Rails.

![Screenshot](https://user-images.githubusercontent.com/10758879/213940403-68400aab-6cc6-40ca-82fb-af049f07581b.gif)

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
  c.max_results = 5 # default is 10

  # Render as a modal that is hidden by default and toggled with a hotkey.
  # The default value for this setting is false - i.e. render inline.
  c.modal = true # default is false

  # Use a custom hotkey to focus the omnibar (or toggle it if it is a modal).
  # CTRL+<hotkey> and CMD+<hotkey> will both work.
  c.hotkey = 't' # default is 'k'

  # Add static items that can be found by fuzzy typing.
  # "suggested" items will be displayed before user starts typing.
  c.add_item(title: 'Important link', url: 'https://www.disney.com', suggested: true)
  c.add_item(title: 'Important info', modal_html: '<b>You rock</b>')

  # Add all backoffice URLs as searchable items
  Rails.application.routes.routes.each do |route|
    next unless route.defaults[:action] == 'index'
    next unless name = route.name[/^backoffice_(.+)/, 1]

    # items can have icons
    # arrows, cloud, cog, dev, document, home, question, search, sparkle, user, wallet, x
    c.add_item(title: name.humanize, url: route.format({}), icon: :cog)
  end

  # Add commands

  # This command will allow searching users by id by typing e.g. 'u123'.
  # The capture group is used to extract the value for the DB query.
  c.add_record_search(
    pattern: /^u(\d+)/,
    example: 'u123',
    model:   User,
  )

  # Search records by column(s) other than id (via LIKE query by default)
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

Render it somewhere. E.g. `app/views/layouts/application.html.erb`:

```erb
<%= Omnibar.render %>
```

If you have a fully decoupled frontend, use `Omnibar.html_url` instead, fetch the omnibar HTML from there, and inject it.

### Authorization

You can limit access to commands (e.g. search commands). This will not limit access to plain items.

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

### Using multiple different omnibars

```ruby
BaseOmnibar = Class.new(RailsOmnibar)
BaseOmnibar.configure do |c|
  c.add_item(
    title: 'Log in',
    url:    Rails.application.routes.url_helpers.log_in_url
  )
end

UserOmnibar = Class.new(RailsOmnibar)
UserOmnibar.configure do |c|
  c.auth = ->{ user_signed_in? }
  c.add_item(
    title: 'Log out',
    url:    Rails.application.routes.url_helpers.log_out_url
  )
end
```

Then, in some layout:

```erb
<%= (user_signed_in? ? UserOmnibar : BaseOmnibar).render %>
```

### Other options and usage patterns

#### Adding multiple items at once

```ruby
MyOmnibar.add_items(
  *MyRecord.all.map { |rec| { title: rec.title, url: url_for(rec) } }
)
```

#### Adding all ActiveAdmin or RailsAdmin index routes as searchable items

Simply call `::add_webadmin_items` and use the `modal` mode.

```ruby
MyOmnibar.configure do |c|
  c.add_webadmin_items
  c.modal = true
end
```

##### To render in ActiveAdmin

```ruby
module AddOmnibar
  def build_page(...)
    within(super) { text_node(MyOmnibar.render) }
  end
end
ActiveAdmin::Views::Pages::Base.prepend(AddOmnibar)
```

##### To render in RailsAdmin

Add `MyOmnibar.render` to `app/views/layouts/rails_admin/application.*`.

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

## License

This program is provided under an MIT open source license, read the [LICENSE.txt](https://github.com/jaynetics/rails_omnibar/blob/master/LICENSE.txt) file for details.
