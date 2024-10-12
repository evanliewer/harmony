# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Retreats::CommentsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :comment, through: :retreat, through_association: :comments

    # GET /api/v1/retreats/:retreat_id/comments
    def index
    end

    # GET /api/v1/retreats/comments/:id
    def show
    end

    # POST /api/v1/retreats/:retreat_id/comments
    def create
      if @comment.save
        render :show, status: :created, location: [:api, :v1, @comment]
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/retreats/comments/:id
    def update
      if @comment.update(comment_params)
        render :show
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/retreats/comments/:id
    def destroy
      @comment.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def comment_params
        strong_params = params.require(:retreats_comment).permit(
          *permitted_fields,
          :name,
          :user_id,
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
  class Api::V1::Retreats::CommentsController
  end
end
