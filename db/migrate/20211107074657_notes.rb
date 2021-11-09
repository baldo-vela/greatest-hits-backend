class Notes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :username
      t.belongs_to :playlist, null: false, foreign_key: true
      # t.string :playlist_id
      t.text :content
    
      t.timestamps
    end
    
  end
end
