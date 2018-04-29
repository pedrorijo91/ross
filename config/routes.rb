Rails.application.routes.draw do

  get 'app/index'

  post 'app/stats', to: 'app#stats', as: :compute

  root 'app#index'
end
