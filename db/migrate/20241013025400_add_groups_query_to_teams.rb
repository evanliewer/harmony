class AddGroupsQueryToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :groups_query, :string
  end
end
