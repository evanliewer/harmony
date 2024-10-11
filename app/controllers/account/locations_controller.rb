class Account::LocationsController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :location, through: :team, through_association: :locations

  # GET /account/teams/:team_id/locations
  # GET /account/teams/:team_id/locations.json
  def index
    delegate_json_to_api
  end

  # GET /account/locations/:id
  # GET /account/locations/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/locations/new
  def new
  end

  # GET /account/locations/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/locations
  # POST /account/teams/:team_id/locations.json
  def create
    respond_to do |format|
      if @location.save
        format.html { redirect_to [:account, @location], notice: I18n.t("locations.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @location] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/locations/:id
  # PATCH/PUT /account/locations/:id.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to [:account, @location], notice: I18n.t("locations.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @location] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/locations/:id
  # DELETE /account/locations/:id.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :locations], notice: I18n.t("locations.notifications.destroyed") }
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
