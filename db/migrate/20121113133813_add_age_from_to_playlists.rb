class AddAgeFromToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :age_from, :datetime
  end
end
