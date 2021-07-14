Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  #Model Related Routes
  namespace :api do
    namespace :v1 do
      resources :tracks
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
  namespace :api do
    namespace :v1 do
      resources :playlists
    end
  end
  namespace :api do
    namespace :v1 do
      resources :game_logs
    end 
  end
  
  #Auth Related Routes
  namespace :api do
    namespace :v1 do
      get '/login', to: "auth#spotify_request"
      get '/auth', to: "auth#show"
      get '/user', to: "users#create"
      patch '/user', to: "users#update"
    end
  end

end

