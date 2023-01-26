class RailsOmnibar
  def render
    @cached_html ||= <<~HTML.html_safe
      <div id='mount-rails-omnibar'>
        <script src='#{urls.js_path}?v=#{RailsOmnibar::VERSION}' type='text/javascript'></script>
        <ninja-keys data-controller='rails-omnibar'></ninja-keys>
        <script type="application/json">#{to_json}</script>
      </div>
    HTML
  end

  require 'js_regex'

  def as_json(*)
    {
      calculator:     calculator?,
      commandPattern: JsRegex.new!(command_pattern, target: 'ES2018'),
      hotkey:         hotkey,
      items:          items,
      maxResults:     max_results,
      modal:          modal?,
      placeholder:    placeholder,
      queryPath:      urls.query_path(omnibar_class: self.class),
    }
  end

  def urls
    @urls ||= RailsOmnibar::Engine.routes.url_helpers
  end

  private

  def clear_cache
    @cached_html = nil
  end
end
