class Note < ApplicationRecord
    # Removing this association, because we aren't caching the user object from spotify
    # belongs_to :user,
    belongs_to :playlist
    # Note: we don't need user association anymore since we aren't pushing a user from the client, just their spotify name
    # validates :content, presence :true
    # validates :username, presence :true
    # validates :playlist_id, presence :true #All notes should have content

end