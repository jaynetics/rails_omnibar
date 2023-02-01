class RailsOmnibar
  def render
    @cached_html ||= <<~HTML.html_safe
      <script src='#{urls.js_path}?v=#{RailsOmnibar::VERSION}' type='text/javascript'></script>
      <div id='mount-rails-omnibar'>
        <script type="application/json">#{to_json}</script>
      </div>
    HTML
  end

  def html_url
    urls.html_path(omnibar_class: omnibar_class)
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
      queryPath:      urls.query_path(omnibar_class: omnibar_class),
    }
  end

  def urls
    @urls ||= RailsOmnibar::Engine.routes.url_helpers
  end

  private

  def check_const_and_clear_cache
    omnibar_class # trigger constant assignment check
    @cached_html = nil
  end
end
