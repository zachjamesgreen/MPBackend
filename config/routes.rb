Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'upload/new', to: 'upload#new'
  post 'upload/upload', to: 'upload#upload'



  root 'index#index'
end
