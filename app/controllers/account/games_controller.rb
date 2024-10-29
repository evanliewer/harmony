class Account::GamesController < Account::ApplicationController
  account_load_and_authorize_resource :game, through: :team, through_association: :games

  # GET /account/teams/:team_id/games
  # GET /account/teams/:team_id/games.json
  def index
    delegate_json_to_api
  end

  # GET /account/games/:id
  # GET /account/games/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/games/new
  def new
  end

  # GET /account/games/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/games
  # POST /account/teams/:team_id/games.json
  def create
    respond_to do |format|
      if @game.save
        format.html { redirect_to [:account, @game], notice: I18n.t("games.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @game] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/games/:id
  # PATCH/PUT /account/games/:id.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to [:edit, :account, @game], notice: I18n.t("games.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @game] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/games/:id
  # DELETE /account/games/:id.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :games], notice: I18n.t("games.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
