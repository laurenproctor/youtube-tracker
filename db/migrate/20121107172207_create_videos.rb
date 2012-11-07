class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :unique_id
      t.text :categories
      t.text :keywords
      t.text :description
      t.string :title
      t.text :thumbnails
      t.string :player_url
      t.datetime :published_at
      t.datetime :uploaded_at

      t.timestamps
    end
    add_index :videos, :title
    add_index :videos, :unique_id
  end
end

