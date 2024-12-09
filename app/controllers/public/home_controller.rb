class Public::HomeController < Public::ApplicationController
  # Redirect `/` to either `ENV["MARKETING_SITE_URL"]` or the sign-in page.
  # If you'd like to customize the action for `/`, you can remove this and define `def index ... end ` below.

 
   def index
    
    if params[:id].present? && params[:id].strip != ""
      @retreat = Retreat.find_by_obfuscated_id(params[:id])
      unless @retreat
        redirect_to new_account_user_path, alert: "Retreat not found." and return
      end
    else
      redirect_to new_account_user_path, alert: "Please log in to access this page." and return
    end

    ActiveStorage::Current.url_options = {host: "https://campdashboard.s3.amazonaws.com"} 
    @planner = User.first
    @schedule = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.schedulable.ids }).where(items: { active: true})
    @timeline = Flights::Check.includes(:flight).where(retreat_id: @retreat.id).where(:flights => { :external => true }).merge(Flight.order(sort_order: :desc))
    @meetingspaces = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Meeting Spaces" }).ids }).where.not(active: false)
    @snacks = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Snacks" }).ids }).where(items: { active: true})
    @questions = Question.joins([:locations]).where(locations: { id: @retreat.location_ids }).order(:sort_order)
    @medforms = Medform.where(retreat_id: @retreat.id)
    @cabins = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Lodging" }).ids }).where.not(active: false)
    @cabin_ids = @cabins.pluck(:item_id)
    @cabin_resources = Item.where(id: @cabin_ids).distinct

  
    

    respond_to do |format|
     format.html { render layout: false }
     format.csv { send_data Item.to_csv(@cabin_resources), filename: "CabinAssignments-#{@retreat&.organization&.name}-#{@retreat.arrival.strftime("%B #{@retreat.arrival.day.ordinalize} %Y")}.csv" }          
    end
    
  end



  def waiver
   if params[:language] == "fr"
     I18n.locale = :fr
    elsif params[:language] == "kr"
     I18n.locale = :kr
    elsif params[:language] == "sp"
     I18n.locale = :sp
    else 
     I18n.locale = :en
    end 
    @retreat = Retreat.find_by_obfuscated_id(params[:retreat])
    @team = @retreat.team
    @medform = Medform.new
  end

  def create_public_waiver
    @retreat = Retreat.first
    @medform = Medform.new(medform_params)
    if @medform.save
      redirect_to thank_you_path(retreat: @medform.retreat.obfuscated_id), notice: 'Thank you for completing the form!'
    else
      # If validation fails, render the public form with errors
      render :waiver, layout: "public"
    end
  end

  def medform_params
    params.require(:medform).permit(:team_id, :name, :phone, :email, :dietary, :retreat_id, :dietary, :age, :gender, :emergency_contact_name, :emergency_contact_phone, :emergency_contact_relationship, :terms, :form_for)
  end

  def game_show
    #action made to have screens show scores for gameshow
    @score = Game.first
    @color = params[:color]
    case params[:color]
      when "red"
        
      when "blue"

      when "yellow"

      when "green"

    end
    #render layout: false
  end

  def public_reservation
    puts "STARTING PUBLIC RESERVATION"
    @path= "https://shuffle.dev/"
    @retreat = Retreat.find_by_obfuscated_id(params[:retreat_id])
    if params[:reservation_id].present?
      @reservation = Reservation.find(params[:reservation_id])
    else   
      @reservation = Reservation.new(team_id: @retreat.team_id)
    end
   puts "About to Render Layout" 
   render :layout => false
  end

  def destroy_reservation
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to root_path(id: @reservation.retreat.obfuscated_id), notice: I18n.t('reservations.notifications.destroyed') }
    end
  end

  def new_public_reservation 
   puts "Reservation ID:" + params[:subaction].to_s + "-----"
   retreat = Retreat.find(params[:retreat_id])
   if params[:update_reservation].present?
      @reservation = Reservation.find(params[:update_reservation])

    begin
       if params[:reservation][:start_time].present?
         @reservation.start_time = ActiveSupport::TimeZone.new('Pacific Time (US & Canada)').parse(params[:reservation][:start_time]).utc
       end
       if params[:reservation][:end_time].present?
         @reservation.end_time = ActiveSupport::TimeZone.new('Pacific Time (US & Canada)').parse(params[:reservation][:end_time]).utc
       else
         @reservation.end_time = @reservation.start_time + 1.hour
       end
    rescue => ex
      puts "Error with times for public reservation"
      puts ex.message
    end
     puts "Quantity and Notes"
     puts "Quantity: " + params[:reservation][:quantity].to_s
     puts "Notes: " + params[:reservation][:notes].to_s
      @reservation.quantity = params[:reservation][:quantity]
      @reservation.notes = params[:reservation][:notes]
     puts "Done with quantity and notes" 
      @reservation.item_id = params[:reservation][:item_id]
      @reservation.items_option_id = params[:reservation][:items_option_id]

   else 
     puts "Create new reservation"

     @reservation = Reservation.new(params.require(:reservation).permit(
          :name,
          :start_time,
          :end_time,
          :notes,
          :retreat_id,
          :item_id,
          :quantity
        ))
     puts "Initialized Reservation"
    @reservation.team_id = retreat.team_id
    @reservation.retreat_id = retreat.id
    @reservation.name = retreat.name.to_s + " " + Item.find(params[:reservation][:item_id]).name.to_s

    @reservation.active = true

    retreat_time_zone = ActiveSupport::TimeZone.new(retreat.team.time_zone)
    @reservation.start_time = retreat_time_zone.parse(params[:reservation][:start_time])


    if params[:reservation][:end_time].present?
      end_time = DateTime.parse(params[:reservation][:end_time])
      @reservation.end_time = end_time.in_time_zone('UTC') #.in_time_zone(retreat.team.time_zone)
    else 
      @reservation.end_time = @reservation.start_time + 1.hour
    end  

  end

     respond_to do |format|
      if @reservation.save!(validate: false)
        1000.times do 
          puts "Can save dawg"
          puts @reservation.name
          puts @reservation.retreat.name
          puts @reservation.retreat.obfuscated_id
        end  
        puts @reservation.notes
        puts "id: " + @reservation.id.to_s
         format.html { redirect_to root_path(id: @reservation.retreat.obfuscated_id), notice: I18n.t('reservations.notifications.created') }
         # format.json { render :show, status: :created, location: [:account, @reservation] }
        else
          puts "You faily"
          format.html { redirect_to root_path(id: retreat.obfuscated_id) }
        #  format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      end  
  end

   



  include RootRedirect

  # Allow your application to disable public sign-ups and be invitation only.
  include InviteOnlySupport

  # Make Bullet Train's documentation available at `/docs`.
  include DocumentationSupport
end
