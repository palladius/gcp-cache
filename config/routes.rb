Rails.application.routes.draw do

  get "/inventory_items/stats", to: "inventory_items#stats" 

  resources :inventory_items
  resources :labels
  resources :folders
  resources :projects
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :orgs

  # Defines the root path route ("/")
  root "folders#index"

end
