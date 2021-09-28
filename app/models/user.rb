require 'rest-client'

class User < ApplicationRecord
    has_many :playlists
    has_many :tracks, through: :playlists

    def access_token_expired?
        (Time.now - self.updated_at) > 2.hours
    end

    def refresh_access_token
        # See #4 'Requesting a Refreshed access token' https://developer.spotify.com/documentation/general/guides/authorization-guide/ 
        if access_token_expired?
            spotify_token_url = "https://accounts.spotify.com/api/token"
            key = "#{Rails.application.credentials.spotify[:spotify_id]}:#{Rails.application.credentials.spotify[:spotify_secret]}"
            header = { 
                Authorization: "Basic #{Base64.strict_encode64(key)}"
                #Note, it must be `strict_encode64` not `encode64`, because the later includes a line return that would have to be pruned.
            }
            body = {
                grant_type: 'refresh_token',
                spotify_refresh_token: self.spotify_refresh_token
                #client_id: Rails.application.credentials.spotify[:spotify_id]
                #client_secret: Rails.application.credentials.spotify[:spotify_secret]
            }
            debugger
            auth_response = RestClient.post(spotify_token_url, body, header)
            auth_params = JSON.parse(auth_response)
            self.update(spotify_access_token: auth_params["access_token"])

        end
    end


end