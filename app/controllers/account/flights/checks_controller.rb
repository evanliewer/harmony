class Account::Flights::ChecksController < Account::ApplicationController
  account_load_and_authorize_resource :check, through: :team, through_association: :flights_checks

  # GET /account/teams/:team_id/flights/checks
  # GET /account/teams/:team_id/flights/checks.json
  def index
    @retreats = Retreat.where(arrival: (Time.zone.now - 7.days)..(Time.zone.now + 6.months)).order(:arrival)
    @event_planners = @retreats.flat_map { |retreat| retreat.planners&.ids }.compact.uniq

    if params[:search].present?
      case params[:search]
      when "due_in_two_weeks"
        from_date = Time.current
        to_date = 2.weeks.from_now

        @checks = Flights::Check.joins(:flight)
                            .where(completed_at: nil) # Exclude completed checks
                            .where.not('flights.warning IS NULL') # Ensure warning exists
                            .where('flights.created_at + (flights.warning * interval \'1 day\') BETWEEN ? AND ?', from_date, to_date)
        @checks = Flights::Check.joins(:flight).where(completed_at: nil)                 

      when "overdue"
        @checks = Flights::Check.all
      when "my_upcoming"
        @checks = Flights::Check.all
      when "my_overdue"
        @checks = Flights::Check.all
     
      else
        @checks = Flights::Check.all
      end
    else 
      @checks = Flights::Check.joins(:retreat).order('retreats.arrival')
    end 

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
