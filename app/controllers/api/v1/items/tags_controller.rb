# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Items::TagsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :tag, through: :team, through_association: :items_tags

    # GET /api/v1/teams/:team_id/items/tags
    def index
    end

    # GET /api/v1/items/tags/:id
    def show
    end

    # POST /api/v1/teams/:team_id/items/tags
    def create
      if @tag.save
        render :show, status: :created, location: [:api, :v1, @tag]
      else
        render json: @tag.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/items/tags/:id
    def update
      if @tag.update(tag_params)
        render :show
      else
        render json: @tag.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/items/tags/:id
    def destroy
      @tag.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def tag_params
        strong_params = params.require(:items_tag).permit(
          *permitted_fields,
          :name,
          :ticketable,
          :schedulable,
          :optionable,
          :exclusivable,
          :cleanable,
          :publicable,
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
  class Api::V1::Items::TagsController
  end
end
