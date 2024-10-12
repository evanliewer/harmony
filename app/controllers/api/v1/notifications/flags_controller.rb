# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Notifications::FlagsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :flag, through: :team, through_association: :notifications_flags

    # GET /api/v1/teams/:team_id/notifications/flags
    def index
    end

    # GET /api/v1/notifications/flags/:id
    def show
    end

    # POST /api/v1/teams/:team_id/notifications/flags
    def create
      if @flag.save
        render :show, status: :created, location: [:api, :v1, @flag]
      else
        render json: @flag.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/notifications/flags/:id
    def update
      if @flag.update(flag_params)
        render :show
      else
        render json: @flag.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/notifications/flags/:id
    def destroy
      @flag.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def flag_params
        strong_params = params.require(:notifications_flag).permit(
          *permitted_fields,
          :name,
          :department_id,
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
  class Api::V1::Notifications::FlagsController
  end
end
