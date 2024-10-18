class Avo::Resources::RetreatsRequest < Avo::BaseResource
  self.includes = []
  self.model_class = ::Retreats::Request
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :retreat, as: :belongs_to
    field :department, as: :belongs_to
    field :notes, as: :text
  end
end
