class ChangeViewTimeForGoals < ActiveRecord::Migration
   def change
    change_table :goals do |t|
      t.change :view_time, :integer
    end
  end
end

