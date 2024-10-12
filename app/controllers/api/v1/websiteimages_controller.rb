# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::WebsiteimagesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :websiteimage, through: :team, through_association: :websiteimages

    # GET /api/v1/teams/:team_id/websiteimages
    def index
    end

    # GET /api/v1/websiteimages/:id
    def show
    end

    # POST /api/v1/teams/:team_id/websiteimages
    def create
      if @websiteimage.save
        render :show, status: :created, location: [:api, :v1, @websiteimage]
      else
        render json: @websiteimage.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/websiteimages/:id
    def update
      if @websiteimage.update(websiteimage_params)
        render :show
      else
        render json: @websiteimage.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/websiteimages/:id
    def destroy
      @websiteimage.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def websiteimage_params
        strong_params = params.require(:websiteimage).permit(
          *permitted_fields,
          :name,
          :description,
          :image,
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
  class Api::V1::WebsiteimagesController
  end
end
