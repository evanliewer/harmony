class CreateRetreatsHostTags < ActiveRecord::Migration[7.1]
  def change
    create_table :retreats_host_tags do |t|
      t.references :retreat, null: false, foreign_key: true
      t.references :host, null: false, foreign_key: {to_table: "memberships"}

      t.timestamps
    end
  end
end
