require 'rest-client'

class User < ApplicationRecord
    has_many :playlists
    has_many :tracks, through: :playlists

    def access_token_expired?
        (Time.now - self.updated_at) > 2.hours
    end

    def refresh_access_token
        if access_token_expired?
            body = {
                grant_type: 'refresh_token',
                spotify_refresh_token: self.spotify_refresh_token,
                client_id: Rails.application.credentials.spotify[:client_id],
                client_secret: Rails.application.credentials.spotify[:client_secret]
            }
            auth_response = RestClient.post("https://accounts.spotify.com/api/token", body)
            auth_params = JSON.parse(auth_response)
            self.update(spotify_access_token: auth_params["access_token"])

        end
    end


end