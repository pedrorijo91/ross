Rails.application.routes.draw do

  get 'app/index'

  post 'app/stats', to: 'app#stats', as: :compute
  get  'app/stats' => redirect("/")
  # TODO get app/stats/username

  get 'app/mockup'

  root 'app#index'
end
