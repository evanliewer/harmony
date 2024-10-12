# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::NotificationsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :notification, through: :team, through_association: :notifications

    # GET /api/v1/teams/:team_id/notifications
    def index
    end

    # GET /api/v1/notifications/:id
    def show
    end

    # POST /api/v1/teams/:team_id/notifications
    def create
      if @notification.save
        render :show, status: :created, location: [:api, :v1, @notification]
      else
        render json: @notification.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/notifications/:id
    def update
      if @notification.update(notification_params)
        render :show
      else
        render json: @notification.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/notifications/:id
    def destroy
      @notification.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def notification_params
        strong_params = params.require(:notification).permit(
          *permitted_fields,
          :name,
          :user_id,
          :read_at,
          :action_text,
          :emailed,
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
  class Api::V1::NotificationsController
  end
end
