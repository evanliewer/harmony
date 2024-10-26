class AddItemsOptionIdToReservations < ActiveRecord::Migration[7.2]
  def change
    add_reference :reservations, :items_option, null: true, foreign_key: {to_table: "items_options"}
  end
end
