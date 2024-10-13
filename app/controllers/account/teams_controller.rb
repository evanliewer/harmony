class Account::TeamsController < Account::ApplicationController
  include Account::Teams::ControllerBase
  filter_resource "Item", [:name, :description, :location], actions: :show

  private

  def permitted_fields
    [
      :item_query,
      :circuitree_api,
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
