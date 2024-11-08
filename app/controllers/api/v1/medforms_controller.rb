# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::MedformsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :medform, through: :team, through_association: :medforms

    # GET /api/v1/teams/:team_id/medforms
    def index
    end

    # GET /api/v1/medforms/:id
    def show
    end

    # POST /api/v1/teams/:team_id/medforms
    def create
      if @medform.save
        render :show, status: :created, location: [:api, :v1, @medform]
      else
        render json: @medform.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/medforms/:id
    def update
      if @medform.update(medform_params)
        render :show
      else
        render json: @medform.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/medforms/:id
    def destroy
      @medform.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def medform_params
        strong_params = params.require(:medform).permit(
          *permitted_fields,
          :name,
          :retreat_id,
          :phone,
          :email,
          :dietary,
          :diet_id,
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
  class Api::V1::MedformsController
  end
end
