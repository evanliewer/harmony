class AddItemQueryToTeam < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :ct_item_query, :string
  end
end
