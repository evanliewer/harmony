class Account::RetreatsController < Account::ApplicationController
  account_load_and_authorize_resource :retreat, through: :team, through_association: :retreats

  # GET /account/teams/:team_id/retreats
  # GET /account/teams/:team_id/retreats.json
  def index
    delegate_json_to_api
  end

  # GET /account/retreats/:id
  # GET /account/retreats/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/retreats/new
  def new
  end

  # GET /account/retreats/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/retreats
  # POST /account/teams/:team_id/retreats.json
  def create
    respond_to do |format|
      if @retreat.save
        format.html { redirect_to [:account, @retreat], notice: I18n.t("retreats.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @retreat] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @retreat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/retreats/:id
  # PATCH/PUT /account/retreats/:id.json
  def update
    respond_to do |format|
      if @retreat.update(retreat_params)
        format.html { redirect_to [:account, @retreat], notice: I18n.t("retreats.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @retreat] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @retreat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/retreats/:id
  # DELETE /account/retreats/:id.json
  def destroy
    @retreat.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :retreats], notice: I18n.t("retreats.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date_and_time(strong_params, :arrival)
    assign_date_and_time(strong_params, :departure)
    assign_select_options(strong_params, :location_ids)
    assign_select_options(strong_params, :demographic_ids)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
