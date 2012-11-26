class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :time_left_days
      t.date :time_left
      t.integer :views
      t.integer :subscribers
      t.string :view_time
      t.integer :facebook_likes

      t.timestamps
    end
  end
end
