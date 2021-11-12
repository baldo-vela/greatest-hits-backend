class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :spotify_id

  has_many :notes
end
