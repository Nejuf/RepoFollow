RepoFollow::Application.routes.draw do
  root to: 'home#index'

  get '/auth/github/callback', to: 'sessions#create'

  get '/sign_up', to: 'sessions#new'
end
