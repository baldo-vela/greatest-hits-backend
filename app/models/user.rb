require 'rest-client'
# Example of User as instanced ActiveRecord object
=begin 
    <User id: 2, 
    name: "foo", 
    email: nil, 
    href: "https://api.spotify.com/v1/users/foo", 
    country: "US", 
    spotify_url: "https://open.spotify.com/user/foo", 
    spotify_id: "foo", 
    spotify_access_token: [FILTERED], 
    spotify_refresh_token: [FILTERED], 
    uri: "spotify:user:foo", 
    image_url: "https://i.scdn.co/image/foo...", 
    created_at: "2021-09-21 20:27:27.652181000 +0000", 
    updated_at: "2021-09-21 21:55:51.195515000 +0000"> 
=end 

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
                refresh_token: self.spotify_refresh_token
            }
            # debugger
            # auth_response = RestClient.post(spotify_token_url, body, header)
            auth_response = RestClient::Request.execute(
                method: :post,
                url: spotify_token_url, 
                payload: body, 
                headers: header
                )
            auth_params = JSON.parse(auth_response)
            self.update(spotify_access_token: auth_params["access_token"])

        end
    end


end