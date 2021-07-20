Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#home'
  resources :artists do
    resources :songs, only: [:show, :new, :create, :edit, :update, :destroy]
    # get '/songs/:artist_id/:song_id', to: 'songs#show', as: 'artist_song' 
    # get '/artists/:artist_id', to: 'artists#show', as: 'artist'
    # saving these for after the project review since i don't want to use restful urls. those are dumb.
  end
  resources :songs, only: [:index, :new, :create]
  resources :genres, only: [:index, :show]
  get '/users/new', to: 'users#new', as: 'new_user'
  get '/users', to: 'users#index', as: 'users'
  get '/users/username', to: 'users#username', as: 'username'
  patch '/users/:id', to: 'users#create_username'
  post '/users', to: 'users#create'
  get '/users/:username', to: 'users#show', as: 'user'
  get '/users/:username/edit', to: 'users#edit', as: 'edit_user'
  get '/users/:username/toggle', to: 'users#toggle_party', as: 'toggle_party'
  post '/usersongs', to: 'user_songs#create', as: 'add_song'
  post '/usersongs/game', to: 'user_songs#add_game', as: 'add_game' 
  # need to test #match to just use one action
  patch '/usersongs', to: 'user_songs#rate_song', as: 'rate_song'
  delete '/usersongs', to: 'user_songs#destroy', as: 'remove_song'
  get '/signin', to: 'sessions#new', as: 'signin'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  get '/auth/:provider/callback', to: 'sessions#create'
  namespace :party do
    root 'static#party'
    get '/:username/playlist', to: 'playlists#index', as: 'playlist'
    get '/:username', to: 'hosts#show'
    get '/:username/playlist/edit', to: 'playlists#edit'
    get '/:username/history', to: 'histories#show', as: 'user_history'
    patch '/:username', to: 'hosts#update'
    delete '/:username', to: 'hosts#destroy'
    get '/:username/guests', to: 'guests#index', as: 'guests_home'
    get '/:username/guests/new', to: 'guests#new', as: 'guests_add_song'
    delete '/guests', to: 'guests#destroy', as: 'clear_song'
    get '/histories', to: 'histories#index'
    get '/:username/add-song', to: 'guests#new'
    post '/:username', to: 'guests#create'
  end
end
