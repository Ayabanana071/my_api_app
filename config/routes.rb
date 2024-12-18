Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get '/me', to: 'sessions#show'

  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  # Defines the root path route ("/")
  # root "posts#index"
  resources :friends, only: [:index, :create]
  get '/friends/search', to: 'friends#search'
  get '/users', to: 'users#search'

  resources :points, only: [:index, :create]

  get '/clear_missions', to: 'clear_missions#index'
  post '/clear_missions', to: 'clear_missions#create_or_update'
  get '/clear_missions/total_clear_missions_count', to: 'clear_missions#total_clear_missions_count'

  resources :wake_up_times, only: [:create]

  get '/early_rises/total_success_count', to: 'early_rises#total_success_count'
  resources :early_rises, only: [:create, :index]

  get 'rankings/weekly', to: 'rankings#weekly'

end
