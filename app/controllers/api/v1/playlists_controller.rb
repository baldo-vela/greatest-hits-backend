require 'rest_client'

class Api::V1::PlaylistController < ApplicationController
    def index
        @playlists = Playlist.all
    end
