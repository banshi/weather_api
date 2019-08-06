Rails.application.routes.draw do
  resources :weather, only: [:create, :index] do
    get :temperature, on: :collection
  end

  match :erase, via: [:delete], to: 'erase#delete'
end
