class Api::V1::AuthController < ApplicationController
    # When the client sends a request to 'api/v1/login' routes to this method
    def spotify_request
        # Spotify API Endpoint
        url = "https://accounts.spotify.com/authorize"
        query_params = {
            client_id: Rails.application.credentials.spotify[:spotify_id],
            # Spotify_id is encoded in the Rails credentials file
            response_type: 'code',
            redirect_uri: 'http://localhost:3001/api/v1/user',
            # Tells the Spotify API where to send the client after the user logs in, See 'api/v1/user_controller.rb'
            scope: "user-library-read 
                    playlist-read-collaborative
                    playlist-modify-private
                    user-modify-playback-state
                    user-read-private
                    user-top-read
                    playlist-modify-public
                    user-read-recently-played
                    user-read-playback-state
                    user-read-currently-playing",
            show_dialog: true
        }
    #Sends the client to the Spotify API with the query params
    redirect_to "#{url}?#{query_params.to_query}"
  end
end
