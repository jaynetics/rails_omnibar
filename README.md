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

You can pick any path.

To limit access, do something like this:

```ruby
authenticate :user, ->(user){ user.superadmin? } do
  mount RailsOmnibar::Engine => '/rails_omnibar'
end
```

### Configuration

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

### Using multiple different omnibars

```ruby
UserOmnibar  = Class.new(RailsOmnibar).configure { ... }
AdminOmnibar = Class.new(RailsOmnibar).configure { ... }

UserOmnibar.render
AdminOmnibar.render
```

### Other options and usage patterns

```ruby
# Add multiple items
MyOmnibar.add_items(
  *MyRecord.all.map { |rec| { title: rec.title, url: url_for(rec) } }
)

# Add ActiveAdmin index routes as searchable items
Admin::UsersController # trigger autoloading (use your own AA namespace)
ActiveAdmin.application.namespaces.first.resources.each do |res|
  index = res.route_collection_path rescue next
  title = res.menu_item&.label.presence || next
  MyOmnibar.add_item(title: title, url: index)
end

# Render in ActiveAdmin (`MyOmnibar.modal = true` recommended)
module AddOmnibar
  def build_page(...)
    within(super) { text_node(MyOmnibar.render) }
  end
end
ActiveAdmin::Views::Pages::Base.prepend(AddOmnibar)

# Add all index routes as searchable items
Rails.application.routes.routes.each do |route|
  next unless route.defaults.values_at(:action, :format) == ['index', nil]
  MyOmnibar.add_item(title: route.name.humanize, url: route.format({}))
end

# Custom record lookup and rendering
MyOmnibar.add_record_search(
  pattern:  /^U(\d+)/,
  example:  'U123',
  model:    User,
  finder:   ->(id)   { User.find_by(admin: true, id: id) },
  itemizer: ->(user) { { title: "Admin #{user.name}", url: admin_url(user), icon: :user } }
)

# Custom search, plus mapping to multiple results
MyOmnibar.add_search(
  description: 'Google',
  pattern:     /^g (.+)/,
  example:     'g kittens',
  finder:      ->(value) { GoogleSearch.fetch(value) },
  itemizer:    ->(res) do
    [
      { title: res.title, url: res.url },
      { title: "#{res.title} @archive", url: "web.archive.org/web/#{res.url}" }
    ]
  end,
)

# Completely custom command
MyOmnibar.add_command(
  description: 'Get count of a DB table',
  pattern:     /COUNT (.+)/i,
  example:     'COUNT users',
  resolver:    ->(value, _omnibar) do
    { title: value.classify.constantize.count.to_s }
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
