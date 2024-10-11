class CreateDepartmentsAppliedTags < ActiveRecord::Migration[7.1]
  def change
    create_table :departments_applied_tags do |t|
      t.references :department, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: {to_table: "items_tags"}

      t.timestamps
    end
  end
end
