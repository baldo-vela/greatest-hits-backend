class Playlists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.string :spotify_id
    
      t.timestamps
    end
    
  end
end
