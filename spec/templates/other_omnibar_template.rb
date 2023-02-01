OtherOmnibar = Class.new(RailsOmnibar)
OtherOmnibar.configure do |c|
  c.modal = true

  c.add_item(title: 'disney', url: 'https://www.disney.com', suggested: true)

  # Use a hotkey that is the same in most keyboard layouts to work around
  # https://bugs.chromium.org/p/chromedriver/issues/detail?id=553
  # (This is only relevant for testing with chromedriver.)
  c.hotkey = 'a'
end
