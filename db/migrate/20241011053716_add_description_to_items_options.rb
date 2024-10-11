class AddDescriptionToItemsOptions < ActiveRecord::Migration[7.1]
  def change
    add_column :items_options, :description, :string
  end
end
