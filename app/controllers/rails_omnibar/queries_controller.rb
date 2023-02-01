class RailsOmnibar::QueriesController < RailsOmnibar::BaseController
  def show
    return head :forbidden unless omnibar.authorize(self)

    render json: omnibar.handle(params[:q], self)
  end
end
