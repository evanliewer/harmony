class Account::NotificationsController < Account::ApplicationController
  account_load_and_authorize_resource :notification, through: :team, through_association: :notifications

  # GET /account/teams/:team_id/notifications
  # GET /account/teams/:team_id/notifications.json
  def index
    delegate_json_to_api
  end

  # GET /account/notifications/:id
  # GET /account/notifications/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/notifications/new
  def new
  end

  # GET /account/notifications/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/notifications
  # POST /account/teams/:team_id/notifications.json
  def create
    respond_to do |format|
      if @notification.save
        format.html { redirect_to [:account, @notification], notice: I18n.t("notifications.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @notification] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/notifications/:id
  # PATCH/PUT /account/notifications/:id.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to [:account, @notification], notice: I18n.t("notifications.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @notification] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/notifications/:id
  # DELETE /account/notifications/:id.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :notifications], notice: I18n.t("notifications.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date_and_time(strong_params, :read_at)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
