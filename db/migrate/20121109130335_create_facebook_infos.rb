class CreateFacebookInfos < ActiveRecord::Migration
  def change
    create_table :facebook_infos do |t|
      t.string :unique_id
      t.string :username
      t.string :name
      t.string :category
      t.string :cover_id
      t.string :website
      t.string :link
      t.text :description

      t.timestamps
    end
    add_index :facebook_infos, :username
    add_index :facebook_infos, :unique_id
  end
end

