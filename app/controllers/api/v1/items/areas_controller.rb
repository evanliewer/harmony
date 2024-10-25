# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Items::AreasController < Api::V1::ApplicationController
    account_load_and_authorize_resource :area, through: :team, through_association: :items_areas

    # GET /api/v1/teams/:team_id/items/areas
    def index
    end

    # GET /api/v1/items/areas/:id
    def show
    end

    # POST /api/v1/teams/:team_id/items/areas
    def create
      if @area.save
        render :show, status: :created, location: [:api, :v1, @area]
      else
        render json: @area.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/items/areas/:id
    def update
      if @area.update(area_params)
        render :show
      else
        render json: @area.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/items/areas/:id
    def destroy
      @area.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def area_params
        strong_params = params.require(:items_area).permit(
          *permitted_fields,
          :name,
          :location_id,
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
  class Api::V1::Items::AreasController
  end
end
