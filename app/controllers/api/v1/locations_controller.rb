# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::LocationsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :location, through: :team, through_association: :locations

    # GET /api/v1/teams/:team_id/locations
    def index
    end

    # GET /api/v1/locations/:id
    def show
    end

    # POST /api/v1/teams/:team_id/locations
    def create
      if @location.save
        render :show, status: :created, location: [:api, :v1, @location]
      else
        render json: @location.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/locations/:id
    def update
      if @location.update(location_params)
        render :show
      else
        render json: @location.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/locations/:id
    def destroy
      @location.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def location_params
        strong_params = params.require(:location).permit(
          *permitted_fields,
          :name,
          :initials,
          :capacity,
          :hex_color,
          :active,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::LocationsController
  end
end
