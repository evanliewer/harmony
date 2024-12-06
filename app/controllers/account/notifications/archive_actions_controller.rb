class Account::Notifications::ArchiveActionsController < Account::ApplicationController
  account_load_and_authorize_resource :archive_action, through: :team, through_association: :notifications_archive_actions, member_actions: [:approve]

  # GET /account/teams/:team_id/notifications/archive_actions
  # GET /account/teams/:team_id/notifications/archive_actions.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    redirect_to [:account, @team, :notifications]
  end

  # GET /account/notifications/archive_actions/:id
  # GET /account/notifications/archive_actions/:id.json
  def show
  end

  # GET /account/teams/:team_id/notifications/archive_actions/new
  def new
  end

  # GET /account/notifications/archive_actions/:id/edit
  def edit
  end

  # POST /account/notifications/archive_actions/:id/approve
  def approve
    respond_to do |format|
      if @archive_action.approve_by(current_membership)
        format.html { redirect_to [:account, @team], notice: I18n.t("notifications/archive_actions.notifications.approved") }
        format.json { render :show, status: :ok, location: [:account, @archive_action] }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @archive_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /account/teams/:team_id/notifications/archive_actions
  # POST /account/teams/:team_id/notifications/archive_actions.json
  def create
    respond_to do |format|
      # TODO We should probably employ Current Attributes in Rails and set this in the model, so the same thing is
      # happening automatically when we create an action via the API endpoint as well.
      @archive_action.created_by = current_membership

      if @archive_action.save
        format.html { redirect_to [:account, @team, :notifications_archive_actions], notice: I18n.t("notifications/archive_actions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @archive_action] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @archive_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/notifications/archive_actions/:id
  # PATCH/PUT /account/notifications/archive_actions/:id.json
  def update
    respond_to do |format|
      if @archive_action.update(archive_action_params)
        format.html { redirect_to [:account, @archive_action], notice: I18n.t("notifications/archive_actions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @archive_action] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @archive_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/notifications/archive_actions/:id
  # DELETE /account/notifications/archive_actions/:id.json
  def destroy
    @archive_action.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :notifications_archive_actions], notice: I18n.t("notifications/archive_actions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    assign_boolean(strong_params, :target_all)
    assign_select_options(strong_params, :target_ids)
    assign_date_and_time(strong_params, :scheduled_for)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
