class ChangeViewTimeForGoals < ActiveRecord::Migration
   def change
    change_column :goals, :view_time, :integer
  end
end

