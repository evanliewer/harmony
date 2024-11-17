class AddLocationToActivityVersions < ActiveRecord::Migration[7.2]
  def change
    add_reference :activity_versions, :location, null: true, foreign_key: false
  end
end
