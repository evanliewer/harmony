class Account::SeasonsController < Account::ApplicationController
  account_load_and_authorize_resource :season, through: :team, through_association: :seasons

  # GET /account/teams/:team_id/seasons
  # GET /account/teams/:team_id/seasons.json
  def index
    delegate_json_to_api
  end

  # GET /account/seasons/:id
  # GET /account/seasons/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/seasons/new
  def new
  end

  # GET /account/seasons/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/seasons
  # POST /account/teams/:team_id/seasons.json
  def create
    respond_to do |format|
      if @season.save
        format.html { redirect_to [:account, @season], notice: I18n.t("seasons.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @season] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/seasons/:id
  # PATCH/PUT /account/seasons/:id.json
  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to [:account, @season], notice: I18n.t("seasons.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @season] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/seasons/:id
  # DELETE /account/seasons/:id.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :seasons], notice: I18n.t("seasons.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date_and_time(strong_params, :season_start)
    assign_date_and_time(strong_params, :season_end)
    assign_date_and_time(strong_params, :start_time)
    assign_date_and_time(strong_params, :end_time)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
