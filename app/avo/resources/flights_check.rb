class Avo::Resources::FlightsCheck < Avo::BaseResource
  self.includes = []
  self.model_class = ::Flights::Check
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :retreat, as: :belongs_to
    field :flight, as: :belongs_to
    field :user, as: :belongs_to
    field :completed_at, as: :date_time
  end
end
