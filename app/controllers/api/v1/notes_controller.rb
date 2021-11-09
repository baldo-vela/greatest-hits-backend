class Api::V1::NotesController < ApplicationController
    # ALL the Notes in system
    # will probably not ever need this
    def index
        @notes = Note.all

        render json: @notes
    end

    # GET /notes/:id
    def show
        render json: @note
    end

    # POST note
    # For now only note creation will instance a playlist
    def create
        @playlist = Playlist.find_by_id(note_params[:spotify_id])
        @note = @playlist.notes.build(note_params)

        if @note.save
            render json: {
                status: 201,
                store: @note
            }, status: :created, location: api_v1_note_path(@note)
            Playlist.create(spotify_id: note_params[:spotify_id])
        else
            render json: {
                status: 422,
                errors: @store.errors.full_messages.join(", ")
            }, status: :unprocessable_entity
        end
    end

    #PATCH/Put /note/:id
    def update
        if @note.update(note_params)
            render json: @note
        else
            render json: @note.errors,
            status: :unprocessable_entity
        end
    end

    #DELETE /note/:id
    def destroy
        if @note.destroy
            render json: {message: "Successfully Deleted", note: @note}
        else
            render json: {message: "Failed to Delete", note: @note}
        end
    end


    ##Helper Methods
    private
        def set_note
            @note = Note.find(params[:id])
        end

        def note_params
            params.require(:note).permit(:content, :username, :playlist_id)
        end

end