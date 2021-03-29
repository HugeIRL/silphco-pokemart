Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :creatures, only: %i[index show]
  resources :cart, only: %i[create destroy]
  root to: "creatures#index"
end
