class Public::HomeController < Public::ApplicationController
  # Redirect `/` to either `ENV["MARKETING_SITE_URL"]` or the sign-in page.
  # If you'd like to customize the action for `/`, you can remove this and define `def index ... end ` below.
 
   def index
    @retreat = Retreat.find(params[:retreat_id])
      if @retreat.present?
        @planner = User.first
        @schedule = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.schedulable.ids }).where(items: { active: true})
        @timeline = Flights::Check.includes(:flight).where(retreat_id: @retreat.id).where(:flights => { :external => true }).merge(Flight.order(sort_order: :desc))
        @meetingspaces = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Meeting Spaces" }).ids }).where.not(active: false)
        @snacks = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Snacks" }).ids }).where(items: { active: true})
        @cabins = Reservation.includes([:item]).where(retreat_id: @retreat.id).joins(:item).where(items: { id: Item.joins(:tags).where(items_tags: { name: "Lodging" }).ids }).where.not(active: false)
        @questions = Question.joins([:locations]).where(locations: { id: @retreat.location_ids }).order(:sort_order)
        render layout: false
      end
  end


  include RootRedirect

  # Allow your application to disable public sign-ups and be invitation only.
  include InviteOnlySupport

  # Make Bullet Train's documentation available at `/docs`.
  include DocumentationSupport
end
