RepoFollow::Application.routes.draw do
  root to: 'home#index'

  # Sessions/Authentication
  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_up', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'

  # Github
  get '/github/public_repos', to: 'github#public_repos'

  # Repos
  post '/repos/follow', to: 'repos#follow'
  resources :repos, only: [:index, :edit]
end
