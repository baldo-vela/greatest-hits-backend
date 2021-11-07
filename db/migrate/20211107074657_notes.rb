class Notes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.integer :playlist_id
      t.string :playlist_spotify_id
      t.text :body
    
      t.timestamps
    end
    
  end
end
