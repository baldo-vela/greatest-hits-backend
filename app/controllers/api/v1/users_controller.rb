require 'rest_client'

class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def create
    # Request refresh and access tokens
    #TODO: Refactor this to use a enviroment variable for the redirct_uri
    body = {
      grant_type: "authorization_code",
      code: params[:code],
      redirect_uri: 'http://localhost:3001/api/v1/user',
      client_id: Rails.application.credentials.spotify[:spotify_id],
      client_secret: Rails.application.credentials.spotify[:spotify_secret]
    }

    auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
    auth_params = JSON.parse(auth_response.body)
    header = {
      Authorization: "Bearer #{auth_params["access_token"]}"
    }

    user_response = RestClient.get("https://api.spotify.com/v1/me", header)
    user_params = JSON.parse(user_response.body)
    
    #Create User
    # TODO: Split this into a helper method
    @user = User.find_or_create_by(
      name: user_params["display_name"], 
      spotify_url: user_params["external_urls"]["spotify"],
      href: user_params["href"],
      uri: user_params["uri"],
      spotify_id: user_params["id"])
      
    image_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
    country = user_params["country"] ? user_params["country"] : nil

    #Update the user if they have image or country
    @user.update(image_url: image_url, country: country)

    #Update the user access/refresh_tokens
    if @user.access_token_expired?
      @user.refresh_access_token
    else
      @user.update(
        spotify_access_token: auth_params["access_token"], 
        spotify_refresh_token: auth_params["refresh_token"]
      )
    end
    # Checks if the userer instance is valid, passes complete user object to frontend
    if @user
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
    #Redirect to Front End app homepage
    # redirect_to "http://localhost:3000/main"
  end

  def update
    @user = User.find_by(id: params[:id])
    puts "params[:id]",  params[:id]
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :image, :country, :spotify_url, :href, :uri, :spotify_id, :access_token, :refresh_token)
  end

end
