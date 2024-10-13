class AddReservationDownloadToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :reservation_download, :string
  end
end
