class RailsOmnibar::BaseController < ActionController::API
  def omnibar
    @omnibar ||= params.fetch('omnibar_class').constantize
  end
end
