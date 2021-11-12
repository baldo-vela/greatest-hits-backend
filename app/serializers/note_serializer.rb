class NoteSerializer < ActiveModel::Serializer
  attributes :id, :user_spotify_id, :content, :created_at, :updated_at
  belongs_to :playlist, class_name: "playlist", foreign_key: "playlist_id"
end
