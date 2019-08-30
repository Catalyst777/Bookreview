Rails.application.routes.draw do
  
  get '/about' => 'home#about'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users

  root to: 'posts#index'
  resources :posts do
    post :confirm, action: :confirm_new, on: :new
  end
  
  post '/likes/:post_id/create' => 'likes#create'
  post '/likes/:post_id/destroy' => 'likes#destroy'
  get 'users/:id/likes' => 'users#likes'

end
