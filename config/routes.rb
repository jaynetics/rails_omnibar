RailsOmnibar::Engine.routes.draw do
  resource :js,    only: :show, defaults: { format: :js }
  resource :html,  only: :show
  resource :query, only: :show
end
