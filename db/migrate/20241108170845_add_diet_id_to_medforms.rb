class AddDietIdToMedforms < ActiveRecord::Migration[7.2]
  def change
    add_reference :medforms, :diet, null: true, foreign_key: true
  end
end
