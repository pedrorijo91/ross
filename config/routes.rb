Rails.application.routes.draw do

  post 'app/stats', to: 'app#stats', as: :compute
  get  'app/stats' => redirect("/")

  get  'app/stats/:username', to: 'app#stats'

  root 'app#index'
end
