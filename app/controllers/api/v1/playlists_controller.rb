class Api::V1::PlaylistsController < ApplicationController
    def index
        @playlists = Playlist.all

        render json: @playlists, include: {
            notes: {}
        }
    end

    def show
        @playlist = Playlist.find_by(spotify_id: params[:spotify_id])
        list_of_notes = @playlist.Notes
        if @playlist
            render json: @playlist, include: :notes
        else
            render json: {error: 'Playlist Not Found'}
        end

    end

    def create
        @playlist = Playlist.build(id: playlist_params[:spotify_id])
    end


    private
    def playlist_params
        params.require(:)
    end
end