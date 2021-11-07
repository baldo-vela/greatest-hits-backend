class Note < ApplicationRecord
    belongs_to :user,
    belongs_to :playlist

    validates :body, presence :true #All notes should have content

end