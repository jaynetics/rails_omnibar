RailsOmnibar::Engine.routes.draw do
  resource :js,    only: :show, defaults: { format: :js }
  resource :query, only: :show
end
