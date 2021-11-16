class Playlist < ApplicationRecord
    #has_many :tracks
    #belongs_to :user
    has_many :notes

    validates :spotify_id, presence: true
end