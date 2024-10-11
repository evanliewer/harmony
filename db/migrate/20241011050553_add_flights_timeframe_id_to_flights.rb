class AddFlightsTimeframeIdToFlights < ActiveRecord::Migration[7.1]
  def change
    add_reference :flights, :flights_timeframe, null: true, foreign_key: {to_table: "flights_timeframes"}
  end
end
