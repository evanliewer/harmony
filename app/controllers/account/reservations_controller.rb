class Account::ReservationsController < Account::ApplicationController
  account_load_and_authorize_resource :reservation, through: :team, through_association: :reservations

  # GET /account/teams/:team_id/reservations
  # GET /account/teams/:team_id/reservations.json
  def index
     if params[:retreat].present?
      @reservations = Reservation.includes([:retreat, :item]).joins(:item => :tags).where(:tags => {:schedulable => true}).where(team_id: current_team.id).where(retreat_id: params[:retreat]).where(items: { active: true}).distinct
    end 
    delegate_json_to_api
  end

  def schedule_json
    @reservations = Reservation.includes(:item).where(retreat_id: params[:retreat_id]).with_schedule_tag
    respond_to do |format|
      format.json do
        # Explicitly convert to array before rendering
        transformed_reservations = @reservations.map do |reservation|
          {
            id: reservation.id,
            start_time: reservation.start_time,
            end_time: reservation.end_time,
            title: reservation.item&.name + (reservation.dining_style.present? ? ": #{reservation.dining_style}" : "")
          }
        end

        render json: transformed_reservations
      end
    end
  end

  def calendar_json
    @reservations = Reservation.includes(:item).where(item_id: params[:item_id])
    respond_to do |format|
      format.json do
        # Explicitly convert to array before rendering
        transformed_reservations = @reservations.map do |reservation|
          {
            id: reservation.id,
            start_time: reservation.start_time,
            end_time: reservation.end_time,
            title: reservation.retreat&.name
          }
        end

        render json: transformed_reservations
      end
    end
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
        format.html { redirect_to [:account, @reservation.retreat], notice: I18n.t("reservations.notifications.created") }
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
        format.html { redirect_to [:account, @reservation.retreat], notice: I18n.t("reservations.notifications.updated") }
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
    @retreat = @reservation.retreat
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @retreat], notice: I18n.t("reservations.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  def create_seasonal_reservations
    puts "Creating Seasonal Reservations"
    retreat = Retreat.find(params[:retreat_id])
    seasons = Season.where(':date BETWEEN season_start AND season_end', date: retreat.arrival.in_time_zone(current_team.time_zone)).where(team_id: current_team.id)
    puts "Season count: " + seasons.count.to_s
    seasons.each do |season|
      puts "This season is called: " + season.name
      (retreat.arrival.in_time_zone(current_team.time_zone).to_date..retreat.departure.in_time_zone(current_team.time_zone).to_date).each do |date|
        puts "date:" + date.to_s
        if date.wday == season.start_time.in_time_zone(current_team.time_zone).wday
          begin
            puts "------- Details ----------"
            puts "Season Name: " + season.name
            puts "Season ID: "  + season.id.to_s
            puts "Item Name" + season.item&.name.to_s
            puts "Season Start: " + season.start_time.to_s
            puts "date.wday: " + date.wday.to_s
         
            puts "------- End ---------"
           
           puts "~~~~~~~~~~~~~~~~~~~~~~"
           start_time = Time.now
           start_time = start_time.change(:year => date.in_time_zone(current_team.time_zone).year, :month => date.in_time_zone(current_team.time_zone).month, :day => date.in_time_zone(current_team.time_zone).day, :hour => season.start_time.in_time_zone(current_team.time_zone).hour.to_i, :min => season.start_time.in_time_zone(current_team.time_zone).min.to_i)
            
           end_time = Time.now
           end_time = end_time.change(:year => date.in_time_zone(current_team.time_zone).year, :month => date.in_time_zone(current_team.time_zone).month, :day => date.in_time_zone(current_team.time_zone).day, :hour => season.end_time.in_time_zone(current_team.time_zone).hour.to_i, :min => season.end_time.in_time_zone(current_team.time_zone).min.to_i)
            reservation = Reservation.find_or_initialize_by(team_id: retreat.team_id, retreat_id: params[:retreat_id], name: season.name)
             reservation.start_time = start_time
             reservation.end_time = end_time      
             reservation.item_id = season.item_id
             reservation.quantity = season.quantity
             reservation.notes = season.notes
             reservation.seasonal_default = true
             reservation.save!(validate: false)   
             puts "Saved"
             puts reservation.start_time.to_s
           
          rescue => ex
            puts ex.message
            puts "Failure"
          end  
        end
      end  
    end
    redirect_to [:account, retreat]
  end

  def remove_seasonal_reservations
    reservations = Reservation.where(retreat_id: params[:retreat_id]).where(seasonal_default: true)
    reservations.delete_all!  ##this is an acts_as_paranoid functions
    redirect_to [:account, Retreat.find(params[:retreat_id])]
  end

  def fullcalendar_update
    puts "Starting Full Calendar Update"
    reservation = Reservation.find(params[:id])
    reservation.update(start_time: params[:start], end_time: params[:end])
    puts "Ending"
    head :ok
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
