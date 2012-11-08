class ChangeRatingAverageDayPlaylists < ActiveRecord::Migration
  def change
    change_table :day_playlists do |t|
      t.change :rating_average, :decimal, :precision => 28, :scale => 7
    end
  end
end

