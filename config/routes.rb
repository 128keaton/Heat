Rails.application.routes.draw do
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

  get 'receive/submit' => 'receive#submit'

  # Assign links to controllers/views
  get '/school' => 'school#index'
  get '/deploy' => 'deploy#index'
  get '/rack' => 'rack#index'
  get '/pull' => 'finalize#index'
  get '/receive' => 'receive#index'
  get '/status' => 'status#index'

  root 'root#index'
end
