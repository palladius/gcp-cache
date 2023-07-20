Rails.application.routes.draw do
  resources :services
  resources :vms
  resources :billing_accounts

  get "/inventory_items/stats", to: "inventory_items#stats"

  get "/pages/stats", to: "pages#stats"
  get "/pages/index", to: "pages#index"

  resources :inventory_items
  resources :labels
  resources :folders
  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :orgs

  # Defines the root path route ("/")
  root "pages#index" # "folders#index"
end
