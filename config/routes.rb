Rails.application.routes.draw do
  resources :creatures, only: %i[index show]
  resources :cart, only: %i[create destroy]
  root to: "creatures#index"
end
