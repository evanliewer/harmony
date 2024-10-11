# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::RetreatsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :retreat, through: :team, through_association: :retreats

    # GET /api/v1/teams/:team_id/retreats
    def index
    end

    # GET /api/v1/retreats/:id
    def show
    end

    # POST /api/v1/teams/:team_id/retreats
    def create
      if @retreat.save
        render :show, status: :created, location: [:api, :v1, @retreat]
      else
        render json: @retreat.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/retreats/:id
    def update
      if @retreat.update(retreat_params)
        render :show
      else
        render json: @retreat.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/retreats/:id
    def destroy
      @retreat.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def retreat_params
        strong_params = params.require(:retreat).permit(
          *permitted_fields,
          :name,
          :description,
          :arrival,
          :departure,
          :guest_count,
          :organization_id,
          :internal,
          :active,
          :jotform,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          location_ids: [],
          demographic_ids: [],
          planner_ids: [],
          host_ids: [],
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::RetreatsController
  end
end
