class Avo::Resources::ItemsArea < Avo::BaseResource
  self.includes = []
  self.model_class = ::Items::Area
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :location, as: :belongs_to
  end
end
