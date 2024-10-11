class Account::FlightsController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :flight, through: :team, through_association: :flights

  # GET /account/teams/:team_id/flights
  # GET /account/teams/:team_id/flights.json
  def index
    delegate_json_to_api
  end

  # GET /account/flights/:id
  # GET /account/flights/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/flights/new
  def new
  end

  # GET /account/flights/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/flights
  # POST /account/teams/:team_id/flights.json
  def create
    respond_to do |format|
      if @flight.save
        format.html { redirect_to [:account, @flight], notice: I18n.t("flights.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @flight] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/flights/:id
  # PATCH/PUT /account/flights/:id.json
  def update
    respond_to do |format|
      if @flight.update(flight_params)
        format.html { redirect_to [:account, @flight], notice: I18n.t("flights.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @flight] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/flights/:id
  # DELETE /account/flights/:id.json
  def destroy
    @flight.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :flights], notice: I18n.t("flights.notifications.destroyed") }
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
