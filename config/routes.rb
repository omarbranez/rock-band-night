Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#home'
  resources :songs
  resources :artists
  resources :genres
  # resources :users
  get '/users/new', to: 'users#new', as: 'new_user'
  get '/users', to:'users#index', as: 'users'
  post '/users', to:'users#create'
  get '/users/:id', to: 'users#show', as: 'user'
  get '/users/:id/edit', to: 'users#edit', as: 'edit_user'
  # get '/usersongs/rate', to: 'user_songs#rate', as: 'rate_song' # this is a partial, no need to route it
  post '/usersongs', to: 'user_songs#create', as: 'add_song'
  post '/usersongs/game', to: 'user_songs#add_game', as: 'add_game' 
  patch '/usersongs', to: 'user_songs#rate_song', as: 'rate_song'
  delete '/usersongs', to: 'user_songs#destroy', as: 'remove_song'
  get '/signin', to: 'session#new', as: 'signin'
  post '/session', to: 'session#create', as: 'session'
  delete '/session', to: 'session#destroy', as: 'logout'

end
