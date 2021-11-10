Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  #Model Related Routes
  namespace :api do
    namespace :v1 do
      resources :notes
      resources :playlists do
        resources :notes #Leaving All resources open here for now
      end
      resources :tracks
      resources :users
    end 
  end
  
  #Auth Related Routes
  namespace :api do
    namespace :v1 do
      post '/login', to: "auth#spotify_request"
      get '/auth', to: "auth#show"
      get '/user', to: "users#create"
      patch '/user', to: "users#update"
    end
  end

end

