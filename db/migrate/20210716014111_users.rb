class Users < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :href
      t.string :country
      t.string :spotify_url
      t.string :spotify_id
      t.string :spotify_access_token
      t.string :spotify_refresh_token
      t.string :uri
      t.string :image_url
      t.timestamps
    end
  end
end
