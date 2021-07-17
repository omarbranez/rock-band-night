Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static#home'
  resources :artists do
    resources :songs, only: [:show, :new, :create]
    # get '/songs/:artist_id/:song_id', to: 'songs#show', as: 'artist_song' 
    # get '/artists/:artist_id', to: 'artists#show', as: 'artist'
    # saving these for after the project review since i don't want to use restful urls. those are dumb.
  end
  resources :songs, except: [:show]
  resources :genres
  get '/users/new', to: 'users#new', as: 'new_user'
  get '/users', to: 'users#index', as: 'users'
  post '/users', to: 'users#create'
  get '/users/:username', to: 'users#show', as: 'user'
  get '/users/:username/edit', to: 'users#edit', as: 'edit_user'
  get '/users/:username/toggle', to: 'users#toggle_party', as: 'toggle_party'
  post '/usersongs', to: 'user_songs#create', as: 'add_song'
  post '/usersongs/game', to: 'user_songs#add_game', as: 'add_game' 
  # need to test #match to just use one action
  patch '/usersongs', to: 'user_songs#rate_song', as: 'rate_song'
  delete '/usersongs', to: 'user_songs#destroy', as: 'remove_song'
  get '/signin', to: 'session#new', as: 'signin'
  post '/session', to: 'session#create', as: 'session'
  delete '/session', to: 'session#destroy', as: 'logout'
  namespace :party do
    root 'static#party'
    get '/:username/playlist', to: 'hosts#index', as: 'playlist'
    get '/:username', to: 'hosts#show'
    get '/:username/edit-playlist', to: 'hosts#edit'
    get '/:username/history', to: 'histories#show'
    patch '/:username', to: 'hosts#update'
    delete '/:username', to: 'hosts#destroy'
    delete '/guests', to: 'guests#destroy', as: 'clear_song'
    get '/histories', to: 'histories#index'
    get '/:username/add-song', to: 'guests#new'
    post '/:username', to: 'guests#create'
  end
end
