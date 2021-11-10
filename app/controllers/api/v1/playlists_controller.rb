class Api::V1::PlaylistsController < ApplicationController
    #Get /playlist
    def index
        @playlists = Playlist.all

        render json: @playlists, include: {
            notes: {}
        }
    end

    #GET playlist/:id
    def show
        @playlist = Playlist.find_or_create_by(spotify_id: params[:spotify_id])
        @notes = @playlist.notes
        if @playlist
            render json: @playlist, include: :notes
        else
            render json: {error: 'Playlist Not Found'}
        end

    end
    #POST /playlist/:id
    def create
        @playlist = Playlist.new(spotify_id: params[:spotify_id])
        if @playlist.save
            render json: @playlist, status: 202, location: @playlist
        else 
            render json: @playlist.errors, status: :unprocessable_entity
        end
    end


    private
    def playlist_params
        params.require(:spotify_id)
    end
end