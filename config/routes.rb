Rails.application.routes.draw do
  get '/inventory' => 'inventory#index'
  get '/inventory/find/:serial_number' => 'inventory#find'
  post 'inventory/add'
  post '/inventory/remove/:id' => 'inventory#remove', as: 'inventory_remove'
  post 'inventory/find'

  devise_for  :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :sessions => "users/sessions" }
  # Define resources for our models.
  resources :machines
  resources :schools, only: [:index, :destroy, :create]
  resources :roles, only: [:index, :destroy, :create]


  # Actually start setting up the routes.
  
  get '/api/export' => 'api#render_as_csv'
  get '/import' => 'root#import', as: 'import'
  post '/import' => 'root#process_file', as: 'process_import'

  get 'deployment/:school' => 'school#export'

  get 'reprint/:serial' => 'api#reprint'
  get 'schools/view'

  get 'api/hostname'

  get 'api/image'

  get 'api/location_status' => 'api#location_quantity'
  get 'api/check_imaged'
  get 'api/serial_lookup'
  get 'api/set_imaged'
  get 'api/hostname/:serial' => 'api#hostname'
  get 'status/list_all_machines'

  get 'api/ou/:serial' => 'api#ou'

  post 'api/hostname' => 'api#hostname'

  post 'api/image' => 'api#image'

  post 'api/asset_tag' => 'api#set_asset_tag'

  post 'api/deploy' => 'api#mark_as_deployed'
  
  post 'api/mark_imaged' => 'api#set_imaged'
  
  get 'api/mark_imaged' => 'api#set_imaged'

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

  get '/schools' => 'schools#index', as: 'schools_index'
  get '/unbox/assign' => 'unbox#assign'

  post '/unbox/assign' => 'unbox#assign'

  post '/unbox/load_schools' => 'unbox#load_schools'

  get 'receive/index' => 'receive#index'

  get 'receive/create' => 'receive#create'

  post 'receive/create' => 'receive#create'

  post 'receive/load_information' => 'receive#load_information'

  get 'roles/index'

  get 'roles/destroy'

  get 'roles/create'

  get '/roles/list' => 'roles#list_roles'
  post '/roles/list' => 'roles#list_roles'

  get '/roles/list/:id' => 'roles#list_location_roles'
  post '/roles/list/:id' => 'roles#list_location_roles'

  get 'welcome/login'

  get 'welcome/failure'



  get '/schools/edit' => 'schools#edit'

  get '/schools/view' => 'schools#view'

  post 'schools/update' => 'schools#update'

  get 'schools/:id' => 'schools#edit'
  get '/schools/deploy/:id' => 'schools#deployment_sheet'
  post 'schools/:id' => 'schools#edit'

  get 'admin_tools/index'

  get '/mark-doa' => 'root#mark_as_doa'
  post '/mark-doa'=> 'root#mark_as_doa'


  get 'rack_list/index'


  # Assign links to controllers/views
  get '/school' => 'school#index'
  get '/deploy' => 'deploy#index'
  get '/rack' => 'rack#index'
  get '/pull' => 'finalize#index'
  get '/receive' => 'receive#index'
  get '/status' => 'status#index'
  get '/unbox' => 'unbox#index'
  get '/roles' => 'roles#index'
  get '/cinnamonroles' => 'roles#index'
  get 'rack/assign' => 'rack#index'
  get 'deploy/assign' => 'deploy#index'
  get 'users/welcome' => 'welcome#index'
  get '/admin' => 'admin_tools#index'
  get '/mark_doa' => 'mark_as_doa#index'
  get '/racks' => 'rack_list#index'

  #root 'welcome#login'
  root 'root#index'
  get '/login' => 'welcome#login'
  #match "/home", to: "root#index", via: [:get]

end
