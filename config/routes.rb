Rails.application.routes.draw do
  devise_for  :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "users/sessions" }
  # Define resources for our models.
  resources :machines
  resources :schools, only: [:index, :destroy, :create]
  resources :roles, only: [:index, :destroy, :create]

  # Actually start setting up the routes.
  get 'schools/view'

  get 'api/hostname'

  get 'api/image'

  post 'api/hostname' => 'api#hostname'

  post 'api/image' => 'api#image'

  post 'api/asset_tag' => 'api#set_asset_tag'

  post 'api/deploy' => 'api#mark_as_deployed'

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

  post 'receive/load_information' => 'receive#load_information'

  get 'roles/index'

  get 'roles/destroy'

  get 'roles/create'

  get 'welcome/login'

  get 'welcome/failure'

  get 'note/index'

  post 'note/notate' => 'note#notate'

  get '/schools/edit' => 'schools#edit'

  get '/schools/view' => 'schools#view'

  post 'schools/update' => 'schools#update'

  get 'schools/:id' => 'schools#edit'

  post 'schools/:id' => 'schools#edit'

  get 'admin_tools/index'

  get 'mark_as_doa/index'
  post 'mark_as_doa/mark_doa' => 'mark_as_doa#mark_doa'

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
  get '/admin' => 'admin_tools#index'
  get '/mark_doa' => 'mark_as_doa#index'

  #root 'welcome#login'
  root 'root#index'

  get '/login' => 'welcome#login'
  #match "/home", to: "root#index", via: [:get]

end
