class Account::ReservationsController < Account::ApplicationController
  account_load_and_authorize_resource :reservation, through: :team, through_association: :reservations

  # GET /account/teams/:team_id/reservations
  # GET /account/teams/:team_id/reservations.json
  def index
    delegate_json_to_api
  end

  # GET /account/reservations/:id
  # GET /account/reservations/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/reservations/new
  def new
  end

  # GET /account/reservations/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/reservations
  # POST /account/teams/:team_id/reservations.json
  def create
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to [:account, @reservation], notice: I18n.t("reservations.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @reservation] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/reservations/:id
  # PATCH/PUT /account/reservations/:id.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to [:account, @reservation], notice: I18n.t("reservations.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @reservation] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/reservations/:id
  # DELETE /account/reservations/:id.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :reservations], notice: I18n.t("reservations.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date_and_time(strong_params, :start_time)
    assign_date_and_time(strong_params, :end_time)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
