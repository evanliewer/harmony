class Account::Items::AreasController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :area, through: :team, through_association: :items_areas

  # GET /account/teams/:team_id/items/areas
  # GET /account/teams/:team_id/items/areas.json
  def index
    delegate_json_to_api
  end

  # GET /account/items/areas/:id
  # GET /account/items/areas/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/items/areas/new
  def new
  end

  # GET /account/items/areas/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/items/areas
  # POST /account/teams/:team_id/items/areas.json
  def create
    respond_to do |format|
      if @area.save
        format.html { redirect_to [:account, @area], notice: I18n.t("items/areas.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @area] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/items/areas/:id
  # PATCH/PUT /account/items/areas/:id.json
  def update
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to [:account, @area], notice: I18n.t("items/areas.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @area] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/items/areas/:id
  # DELETE /account/items/areas/:id.json
  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :items_areas], notice: I18n.t("items/areas.notifications.destroyed") }
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
