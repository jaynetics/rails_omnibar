class RailsOmnibar::QueriesController < RailsOmnibar::BaseController
  def show
    omnibar = params['omnibar_class'].constantize
    res = omnibar.handle(params[:q])
    render json: omnibar.handle(params[:q])
  end
end
