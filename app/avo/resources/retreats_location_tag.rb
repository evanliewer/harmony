class Avo::Resources::RetreatsLocationTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Retreats::LocationTag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :retreat, as: :belongs_to
    field :location, as: :belongs_to
  end
end
