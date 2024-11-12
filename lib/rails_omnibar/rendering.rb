class RailsOmnibar
  def render(context = nil)
    @context = context
    <<~HTML.html_safe
      <script src='#{urls.js_path}?v=#{RailsOmnibar::VERSION}' type='text/javascript'></script>
      <div class='mount-rails-omnibar'>
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
      commandPattern: command_pattern,
      hotkey:         hotkey,
      items:          items.select { |i| i.render?(context: @context, omnibar: self) },
      maxResults:     max_results,
      modal:          modal?,
      placeholder:    placeholder,
      queryPath:      urls.query_path(omnibar_class: omnibar_class),
    }
  end

  def urls
    @urls ||= RailsOmnibar::Engine.routes.url_helpers
  end
end
