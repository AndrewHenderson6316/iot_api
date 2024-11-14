Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "data_entries#index"
  resources :data_entries 
    resources :data_types
  
    resources :time_of_sample
    
    resources :devices
end
