class Account::Flights::TimeframesController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :timeframe, through: :team, through_association: :flights_timeframes

  # GET /account/teams/:team_id/flights/timeframes
  # GET /account/teams/:team_id/flights/timeframes.json
  def index
    delegate_json_to_api
  end

  # GET /account/flights/timeframes/:id
  # GET /account/flights/timeframes/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/flights/timeframes/new
  def new
  end

  # GET /account/flights/timeframes/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/flights/timeframes
  # POST /account/teams/:team_id/flights/timeframes.json
  def create
    respond_to do |format|
      if @timeframe.save
        format.html { redirect_to [:account, @timeframe], notice: I18n.t("flights/timeframes.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @timeframe] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @timeframe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/flights/timeframes/:id
  # PATCH/PUT /account/flights/timeframes/:id.json
  def update
    respond_to do |format|
      if @timeframe.update(timeframe_params)
        format.html { redirect_to [:account, @timeframe], notice: I18n.t("flights/timeframes.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @timeframe] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @timeframe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/flights/timeframes/:id
  # DELETE /account/flights/timeframes/:id.json
  def destroy
    @timeframe.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :flights_timeframes], notice: I18n.t("flights/timeframes.notifications.destroyed") }
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
