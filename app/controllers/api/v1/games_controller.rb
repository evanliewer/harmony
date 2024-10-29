# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::GamesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :game, through: :team, through_association: :games

    # GET /api/v1/teams/:team_id/games
    def index
    end

    # GET /api/v1/games/:id
    def show
    end

    # POST /api/v1/teams/:team_id/games
    def create
      if @game.save
        render :show, status: :created, location: [:api, :v1, @game]
      else
        render json: @game.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/games/:id
    def update
      if @game.update(game_params)
        render :show
      else
        render json: @game.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/games/:id
    def destroy
      @game.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def game_params
        strong_params = params.require(:game).permit(
          *permitted_fields,
          :red_score,
          :blue_score,
          :yellow_score,
          :green_score,
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
  class Api::V1::GamesController
  end
end
