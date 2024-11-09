class Account::RetreatsController < Account::ApplicationController
  account_load_and_authorize_resource :retreat, through: :team, through_association: :retreats
  before_action :set_paper_trail_whodunnit

  # GET /account/teams/:team_id/retreats
  # GET /account/teams/:team_id/retreats.json
  def index
    @retreats = Retreat.all.order(:name).limit(9)
    @onsite_retreats = Retreat.where('arrival <= ? AND departure >= ?', Time.zone.now, Time.zone.now)

    delegate_json_to_api
  end

  # GET /account/retreats/:id
  # GET /account/retreats/:id.json
  def show
    create_flights
    delegate_json_to_api
    @meals = Reservation.includes([:items_option, :item]).where(retreat_id: @retreat.id, item_id: Item.where(name: ["Breakfast", "Lunch", "Dinner"], team_id: current_team.id).ids, team_id: current_team.id)
    @meetingspaces = Reservation.where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Meeting Spaces" }).ids }).where.not(active: false)
    @lodging = Reservation.where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Lodging" }).ids }).where.not(active: false).order(:name)
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

  def create_flights
     flights = Flights::Check.includes([:flight]).where(retreat_id: @retreat.id).where(team_id: current_team.id)
    unless flights.any?
      Flight.where(team_id: current_team.id).each do |flight|
        Flights::Check.create!(flight_id: flight.id, retreat_id: @retreat.id, team_id: current_team.id, name: @retreat.name + " " + flight.name)
      end
    end 
  end  

  def print
    @retreat = Retreat.find(params[:retreat_id])
    @retreats = Retreat.all.limit(6)
    @meals = Reservation.includes([:items_option, :item]).where(retreat_id: @retreat.id, item_id: Item.where(name: ["Breakfast", "Lunch", "Dinner"], team_id: current_team.id).ids, team_id: current_team.id)
    @meetingspaces = Reservation.where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Meeting Spaces" }).ids }).where.not(active: false)
    @lodging = Reservation.where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Lodging" }).ids }).where.not(active: false).order(:name)
    @schedule = Reservation.joins([:team, :item]).where(retreat_id: @retreat.id, item_id: Item.where(team_id: current_team.id).schedulable, team_id: current_team.id).where(items: { active: true }).order(:start_time)

    render layout: false
  end

   def gold
    @retreat = Retreat.find(params[:retreat_id])
    @retreats = Retreat.all.limit(6)
    render layout: false
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
    assign_select_options(strong_params, :planner_ids)
    assign_select_options(strong_params, :host_ids)
    assign_select_options(strong_params, :contact_ids)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
