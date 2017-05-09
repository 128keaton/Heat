Rails.application.routes.draw do

  # Define resources for our models.
  resources :machines
  resources :schools, only: [:index, :destroy, :create]
  resources :roles, only: [:index, :destroy, :create]

  # Actually start setting up the routes.

  get 'status/index'

  get 'root/index'

  get 'finalize/index'

  get 'finalize/assign'

  get 'deploy/index'

  get 'deploy/assign'

  get 'rack/index'

  get 'rack/assign'

  get 'school/index'

  get 'school/assign'

  post 'school/assign' => 'school#assign'

  post 'school/load_schools' => 'school#load_schools'

  get 'receive/index' => 'receive#index'

  get 'receive/create' => 'receive#create'

  post 'receive/create' => 'receive#create'

  get 'roles/index'

  get 'roles/destroy'

  get 'roles/create'

  # Assign links to controllers/views
  get '/school' => 'school#index'
  get '/deploy' => 'deploy#index'
  get '/rack' => 'rack#index'
  get '/pull' => 'finalize#index'
  get '/receive' => 'receive#index'
  get '/status' => 'status#index'
  get '/schools' => 'schools#index'
  get '/roles' => 'roles#index'
  get '/cinnamonroles' => 'roles#index'

  root 'root#index'

end
