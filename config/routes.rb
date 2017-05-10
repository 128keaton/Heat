Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "users/sessions" }
  # Define resources for our models.
  resources :machines
  resources :schools, only: [:index, :destroy, :create]
  resources :roles, only: [:index, :destroy, :create]

  # Actually start setting up the routes.

  get 'api/hostname'

  get 'api/image'

  post 'api/hostname' => 'api#hostname'

  post 'api/image' => 'api#image'

  get 'api/hostname' => 'api#hostname'

  get 'api/index'

  get '/api' => 'api#index'

  get 'status/index'

  get 'root/index'

  get 'finalize/index'

  get 'finalize/assign'

  get 'deploy/index'

  get 'deploy/assign'

  post 'deploy/pull' => "deploy#pull"

  post 'deploy/load_schools' => 'deploy#load_schools'

  get 'rack/index'

  get 'rack/assign'

  post 'rack/assign' => 'rack#assign'

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

  get 'welcome/login'

  get 'welcome/failure'

  get 'note/index'

  post 'note/notate' => 'note#notate'

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
  get 'rack/assign' => 'rack#index'
  get 'deploy/assign' => 'deploy#index'
  get 'users/welcome' => 'welcome#index'
  get '/notes' => 'note#index'

  root 'welcome#login'

end
