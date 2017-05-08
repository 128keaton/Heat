Rails.application.routes.draw do

  resources :machines
 

  get 'schools/index'
  post 'schools/create' => 'schools#create'
  get 'schools/create' => 'schools#index'
  get 'schools/:id' => 'schools#index'
  delete 'schools/:id' => 'schools#destroy'

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

  get 'receive/index' => 'receive#index'

  get 'receive/create' => 'receive#create'
  post 'receive/create' => 'receive#create'


  # Assign links to controllers/views
  get '/school' => 'school#index'
  get '/deploy' => 'deploy#index'
  get '/rack' => 'rack#index'
  get '/pull' => 'finalize#index'
  get '/receive' => 'receive#index'
  get '/status' => 'status#index'
  get '/schools' => 'schools#index'

  root 'root#index'
end
