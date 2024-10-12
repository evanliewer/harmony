class Account::Notifications::RequestsController < Account::ApplicationController
  account_load_and_authorize_resource :request, through: :team, through_association: :notifications_requests

  # GET /account/teams/:team_id/notifications/requests
  # GET /account/teams/:team_id/notifications/requests.json
  def index
    delegate_json_to_api
  end

  # GET /account/notifications/requests/:id
  # GET /account/notifications/requests/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/notifications/requests/new
  def new
  end

  # GET /account/notifications/requests/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/notifications/requests
  # POST /account/teams/:team_id/notifications/requests.json
  def create
    respond_to do |format|
      if @request.save
        format.html { redirect_to [:account, @request], notice: I18n.t("notifications/requests.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @request] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/notifications/requests/:id
  # PATCH/PUT /account/notifications/requests/:id.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to [:account, @request], notice: I18n.t("notifications/requests.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @request] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/notifications/requests/:id
  # DELETE /account/notifications/requests/:id.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :notifications_requests], notice: I18n.t("notifications/requests.notifications.destroyed") }
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
