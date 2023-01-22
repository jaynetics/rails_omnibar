class RailsOmnibar
  cattr_accessor(:max_results) { 10 }

  def self.render
    @cached_html ||= <<~HTML.html_safe
      <script src='#{urls.js_path}?v=#{RailsOmnibar::VERSION}' type='text/javascript'></script>
      <div id='mount-rails-omnibar'>
        <script type="application/json">#{to_json}</script>
      </div>
    HTML
  end

  require 'js_regex'

  def self.as_json(*)
    {
      calculator:     calculator?,
      commandPattern: JsRegex.new!(command_pattern, target: 'ES2018'),
      hotkey:         hotkey,
      items:          items,
      maxResults:     max_results,
      modal:          modal?,
      placeholder:    placeholder,
      queryPath:      urls.query_path(omnibar_class: self),
    }
  end

  def self.urls
    @urls ||= RailsOmnibar::Engine.routes.url_helpers
  end

  private_class_method\
  def self.clear_cache
    @cached_html = nil
  end
end
