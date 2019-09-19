Rails.application.routes.draw do

  post 'app/stats', to: 'app#form_post', as: :compute
  get  'app/stats' => redirect("/")

  get  'app/stats/:username', to: 'app#stats'

  root 'app#index'
end
