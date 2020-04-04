Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'upload/new',      to: 'upload#new'
  post 'upload/upload',  to: 'upload#upload'
  get '/api/songs',      to: 'playerapi#songs'
  get '/api/album/:id',  to: 'playerapi#album'
  get '/api/albums',     to: 'playerapi#albums'
  get '/api/artists',    to: 'playerapi#artists'
  get '/api/artist/:id', to: 'playerapi#artist'



  root 'index#index'
end
