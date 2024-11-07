class Public::HomeController < Public::ApplicationController
  # Redirect `/` to either `ENV["MARKETING_SITE_URL"]` or the sign-in page.
  # If you'd like to customize the action for `/`, you can remove this and define `def index ... end ` below.

 
   def index
    
    if params[:retreat_id].present?
      @retreat = Retreat.find(params[:retreat_id])
    else 
      @retreat = Retreat.first
    end    
      @planner = User.first
      @schedule = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.schedulable.ids }).where(items: { active: true})
      @timeline = Flights::Check.includes(:flight).where(retreat_id: @retreat.id).where(:flights => { :external => true }).merge(Flight.order(sort_order: :desc))
      @meetingspaces = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Meeting Spaces" }).ids }).where.not(active: false)
      @snacks = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Snacks" }).ids }).where(items: { active: true})
      @cabins = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Lodging" }).ids }).where.not(active: false)
      @questions = Question.joins([:locations]).where(locations: { id: @retreat.location_ids }).order(:sort_order)
      render layout: false
      
  end

  def waiver
    @retreat = Retreat.first
    @team = @retreat.team
    @medform = Medform.new
    100.times do  
      puts "waiver method"
    end  
  end

  def create_public_waiver
    100.times do  
      puts "create_public_waiver"
    end
    @retreat = Retreat.first
    @team = @retreat.team
    @medform = Medform.new(medform_params)
    if @medform.save
      redirect_to thank_you_path, notice: 'Thank you for completing the form!'
    else
      50.times do 
        puts @medform.errors.full_messages if @medform.errors.any?
      end
      @evan = @medform.errors.full_messages
       100.times do  
          puts "validation fail"
        end
      # If validation fails, render the public form with errors
      render :waiver, layout: "public"
    end
  end

  def medform_params
    params.require(:medform).permit(:team_id, :name, :phone, :email, :dietary, :retreat_id)
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


  include RootRedirect

  # Allow your application to disable public sign-ups and be invitation only.
  include InviteOnlySupport

  # Make Bullet Train's documentation available at `/docs`.
  include DocumentationSupport
end
