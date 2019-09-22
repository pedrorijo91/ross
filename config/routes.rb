Rails.application.routes.draw do

  post '/stats', to: 'app#form_post', as: :compute
  get  '/stats' => redirect('/')

  get  '/stats/:username', to: 'app#stats', as: :user_stats

  root 'app#index', as: :home
end
