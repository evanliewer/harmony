class AddAbbreviationToDiets < ActiveRecord::Migration[7.2]
  def change
    add_column :diets, :abbreviation, :string
  end
end
