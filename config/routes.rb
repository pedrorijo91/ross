Rails.application.routes.draw do

  get 'app/index'

  post 'app/stats', to: 'app#stats', as: :compute
  get  'app/stats' => redirect("/")

  root 'app#index'
end
