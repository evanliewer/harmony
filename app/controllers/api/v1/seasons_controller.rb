# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::SeasonsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :season, through: :team, through_association: :seasons

    # GET /api/v1/teams/:team_id/seasons
    def index
    end

    # GET /api/v1/seasons/:id
    def show
    end

    # POST /api/v1/teams/:team_id/seasons
    def create
      if @season.save
        render :show, status: :created, location: [:api, :v1, @season]
      else
        render json: @season.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/seasons/:id
    def update
      if @season.update(season_params)
        render :show
      else
        render json: @season.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/seasons/:id
    def destroy
      @season.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def season_params
        strong_params = params.require(:season).permit(
          *permitted_fields,
          :name,
          :item_id,
          :season_start,
          :season_end,
          :start_time,
          :end_time,
          :quantity,
          :notes,
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
  class Api::V1::SeasonsController
  end
end
