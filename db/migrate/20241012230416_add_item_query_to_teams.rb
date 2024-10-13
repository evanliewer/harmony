class AddItemQueryToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :item_query, :string
  end
end
