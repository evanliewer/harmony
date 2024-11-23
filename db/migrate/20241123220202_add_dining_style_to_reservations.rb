class AddDiningStyleToReservations < ActiveRecord::Migration[7.2]
  def change
    add_column :reservations, :dining_style, :string
  end
end
