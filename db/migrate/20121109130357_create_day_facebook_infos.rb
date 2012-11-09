class CreateDayFacebookInfos < ActiveRecord::Migration
  def change
    create_table :day_facebook_infos do |t|
      t.integer :facebook_info_id
      t.string :unique_id
      t.datetime :imported_date
      t.integer :likes
      t.integer :talking_about_count

      t.timestamps
    end
    add_index :day_facebook_infos, :facebook_info_id
    add_index :day_facebook_infos, :imported_date
    add_index :day_facebook_infos, :unique_id
  end
end

