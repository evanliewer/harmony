class AddNpsAndDebriefToRetreats < ActiveRecord::Migration[7.2]
  def change
    add_column :retreats, :nps, :integer
    add_column :retreats, :debrief, :string
  end
end
