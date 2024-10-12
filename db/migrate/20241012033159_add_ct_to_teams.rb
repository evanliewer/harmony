class AddCtToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :ct_api, :string
    add_column :teams, :ct_query, :string
  end
end
