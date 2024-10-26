# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::ItemsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :item, through: :team, through_association: :items

    # GET /api/v1/teams/:team_id/items
    def index
    end

    # GET /api/v1/items/:id
    def show
    end

    # POST /api/v1/teams/:team_id/items
    def create
      if @item.save
        render :show, status: :created, location: [:api, :v1, @item]
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/items/:id
    def update
      if @item.update(item_params)
        render :show
      else
        render json: @item.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/items/:id
    def destroy
      @item.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def item_params
        strong_params = params.require(:item).permit(
          *permitted_fields,
          :name,
          :description,
          :location_id,
          :active,
          :overlap_offset,
          :image_tag,
          :clean,
          :flip_time,
          :beds,
          :layout,
          :layout_removal,
          :items_area_id,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          tag_ids: [],
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::ItemsController
  end
end
