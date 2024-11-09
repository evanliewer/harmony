class AddActualGroupSizeToRetreats < ActiveRecord::Migration[7.2]
  def change
    add_column :retreats, :actual_group_size, :integer
  end
end
