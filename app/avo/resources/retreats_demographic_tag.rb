class Avo::Resources::RetreatsDemographicTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Retreats::DemographicTag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :retreat, as: :belongs_to
    field :demographic, as: :belongs_to
  end
end
