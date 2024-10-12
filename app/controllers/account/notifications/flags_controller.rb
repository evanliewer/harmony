class Account::Notifications::FlagsController < Account::ApplicationController
  account_load_and_authorize_resource :flag, through: :team, through_association: :notifications_flags

  # GET /account/teams/:team_id/notifications/flags
  # GET /account/teams/:team_id/notifications/flags.json
  def index
    delegate_json_to_api
  end

  # GET /account/notifications/flags/:id
  # GET /account/notifications/flags/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/notifications/flags/new
  def new
  end

  # GET /account/notifications/flags/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/notifications/flags
  # POST /account/teams/:team_id/notifications/flags.json
  def create
    respond_to do |format|
      if @flag.save
        format.html { redirect_to [:account, @flag], notice: I18n.t("notifications/flags.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @flag] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/notifications/flags/:id
  # PATCH/PUT /account/notifications/flags/:id.json
  def update
    respond_to do |format|
      if @flag.update(flag_params)
        format.html { redirect_to [:account, @flag], notice: I18n.t("notifications/flags.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @flag] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/notifications/flags/:id
  # DELETE /account/notifications/flags/:id.json
  def destroy
    @flag.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :notifications_flags], notice: I18n.t("notifications/flags.notifications.destroyed") }
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
