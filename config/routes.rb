Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "data_entries#index"
  resources :data_entries 
    resources :data_types
    resources :time_of_sample
    resources :devices
    resources :sensors

  # Route for chart data
  get 'raw_data', to: 'raw_data#index'
  get 'all_data', to: 'all_data#index'

end
