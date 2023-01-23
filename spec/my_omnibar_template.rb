MyOmnibar = RailsOmnibar.configure do |c|
  c.modal = true

  c.add_item(title: 'important URL', url: 'https://www.disney.com')
  c.add_item(title: 'boring URL', url: 'https://www.github.com')

  c.add_record_search(pattern: /^u(\d+)/, model: User, example: 'u123')

  c.add_record_search(pattern: /^u (.+)/, model: User, columns: %i[first_name last_name],
                      example: 'u Joe')

  c.add_record_search(
    pattern:  /^U(\d+)/,
    example:  'U123',
    model:    User,
    finder:   ->(id)   { User.where(admin: true, id: input[1..]) },
    itemizer: ->(user) { { title: "Admin #{user.name}", url: admin_url(user) } }
  )

  c.add_search(
    pattern:     /^g (.+)/,
    example:     'g kittens',
    finder:      ->(input) { %i[fake_result_1 fake_result_2 fake_result_3] },
    itemizer:    ->(entry) do
      [
        { title: entry, url: '/' },
        { title: entry.to_s.upcase, url: '/' },
      ]
    end,
    description: 'Google',
  )

  c.add_command(
    description: 'Get count of a DB table',
    pattern:     /COUNT (.+)/i,
    example:     'COUNT users',
    resolver:    ->(value, _omnibar) do
      { title: value.classify.constantize.count.to_s }
    rescue => e
      { title: e.message }
    end,
  )

  c.add_help

  # Use a hotkey that is the same in most keyboard layouts to work around
  # https://bugs.chromium.org/p/chromedriver/issues/detail?id=553
  # (This is only relevant for testing with chromedriver.)
  c.hotkey = 'm'
end
