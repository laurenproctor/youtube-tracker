class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :title
      t.text :description
      t.text :summary
      t.string :playlist_id
      t.text :xml
      t.datetime :published_at
      t.string :response_code

      t.timestamps
    end
    add_index :playlists, :title
    add_index :playlists, :playlist_id
  end
end

