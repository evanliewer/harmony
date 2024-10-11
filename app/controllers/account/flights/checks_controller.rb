class Account::Flights::ChecksController < Account::ApplicationController
  account_load_and_authorize_resource :check, through: :team, through_association: :flights_checks

  # GET /account/teams/:team_id/flights/checks
  # GET /account/teams/:team_id/flights/checks.json
  def index
    delegate_json_to_api
  end

  # GET /account/flights/checks/:id
  # GET /account/flights/checks/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/flights/checks/new
  def new
  end

  # GET /account/flights/checks/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/flights/checks
  # POST /account/teams/:team_id/flights/checks.json
  def create
    respond_to do |format|
      if @check.save
        format.html { redirect_to [:account, @check], notice: I18n.t("flights/checks.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @check] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @check.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/flights/checks/:id
  # PATCH/PUT /account/flights/checks/:id.json
  def update
    respond_to do |format|
      if @check.update(check_params)
        format.html { redirect_to [:account, @check], notice: I18n.t("flights/checks.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @check] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @check.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/flights/checks/:id
  # DELETE /account/flights/checks/:id.json
  def destroy
    @check.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :flights_checks], notice: I18n.t("flights/checks.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date_and_time(strong_params, :completed_at)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
