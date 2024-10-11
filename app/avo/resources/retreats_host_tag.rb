class Avo::Resources::RetreatsHostTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Retreats::HostTag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :retreat, as: :belongs_to
    field :host, as: :belongs_to
  end
end
