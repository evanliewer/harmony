class Api::V1::Notifications::ArchiveActionsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :archive_action, through: :team, through_association: :notifications_archive_actions

  # GET /api/v1/teams/:team_id/notifications/archive_actions
  def index
  end

  # GET /api/v1/notifications/archive_actions/:id
  def show
  end

  # POST /api/v1/teams/:team_id/notifications/archive_actions
  def create
    if @archive_action.save
      render :show, status: :created, location: [:api, :v1, @archive_action]
    else
      render json: @archive_action.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/notifications/archive_actions/:id
  def update
    if @archive_action.update(archive_action_params)
      render :show
    else
      render json: @archive_action.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/notifications/archive_actions/:id
  def destroy
    @archive_action.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def archive_action_params
      strong_params = params.require(:notifications_archive_action).permit(
        *permitted_fields,
        :target_all,
        :scheduled_for,
        :created_by,
        :approved_by,
        # 🚅 super scaffolding will insert new fields above this line.
        *permitted_arrays,
        target_ids: [],
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      process_params(strong_params)

      strong_params
    end
  end

  include StrongParameters
end
