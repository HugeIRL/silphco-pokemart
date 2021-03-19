Rails.application.routes.draw do
  resources :creatures, only: %i[index show]
  root to: "creatures#index"
end
