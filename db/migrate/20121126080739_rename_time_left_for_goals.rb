class RenameTimeLeftForGoals < ActiveRecord::Migration
  def change
    rename_column :goals, :time_left, :time_target
  end
end

