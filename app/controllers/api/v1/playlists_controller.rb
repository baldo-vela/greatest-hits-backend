class Api::V1::PlaylistsController < ApplicationController
    # Sets the current instance of playlist object in controller
    before_action :set_playlist, only: [:show, :update, :destroy]
    
    #Get /playlist
    def index
        @playlists = Playlist.all.includes(:notes)
        render json: {
            data: ActiveModelSerializers::SerializableResource.new(@playlists, each_serializer: PlaylistSerializer),
            message: ["Playlists retrieved successfully"],
            status: 200,
            type: "Success"
        }

    end

    #GET playlist/:id
    def show
        if @playlist
            @notes = @playlist.notes
            render json: {
                data: ActiveModelSerializers::SerializableResource.new(@playlist, serializer: PlaylistSerializer),
                message: ['Playlist fetched successfully'],
                status: 200,
                type: 'Success'
              }
        else
            # TODO: improve error handling
            render json: {
                error: 'Playlist Not Found',
                status: 404,
                type: 'Error'
            }
        end

    end
    #POST /playlist/:id
    def create
        @playlist = Playlist.new(playlist_params)
        if @playlist.save
            render json: @playlist, status: 202, type: 'Success'
        else 
            render json: @playlist.errors, status: :unprocessable_entity
        end
    end


    private
    def set_playlist
        @playlist = Playlist.find_by(spotify_id: params[:spotify_id])
    end

    def playlist_params
        params.require(:playlist).permit(:spotify_id)
    end
end