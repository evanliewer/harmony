class AddCircuitreeApiToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :circuitree_api, :string
  end
end
