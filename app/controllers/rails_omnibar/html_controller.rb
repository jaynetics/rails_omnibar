class RailsOmnibar::HtmlController < RailsOmnibar::BaseController
  def show
    render html: omnibar.render(self)
  end
end
