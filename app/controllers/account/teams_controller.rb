class Account::TeamsController < Account::ApplicationController
  include Account::Teams::ControllerBase
  filter_resource "Item", [:name, :description, :location], actions: :show

  def update_fullcalendar_event
  # Find the reservation by ID
  reservation = Reservation.find(params[:id])

  # Update the start and end times
  if reservation.update(start_time: params[:start], end_time: params[:end])
    render json: { success: true }
  else
    render json: { success: false, errors: reservation.errors.full_messages }, status: :unprocessable_entity
  end
end

  private

  def permitted_fields
    [
      :item_query,
      :circuitree_api,
      :groups_query,
      :reservation_download,
      # 🚅 super scaffolding will insert new fields above this line.
    ]
  end

  def permitted_arrays
    {
      # 🚅 super scaffolding will insert new arrays above this line.
    }
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
    strong_params
  end
end
