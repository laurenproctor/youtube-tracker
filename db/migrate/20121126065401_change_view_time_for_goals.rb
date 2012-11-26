class ChangeViewTimeForGoals < ActiveRecord::Migration
   def change
    remove_column :goals, :view_time
    add_column :goals, :view_time, :integer
  end
end

