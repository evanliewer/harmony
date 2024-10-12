class Avo::Resources::RetreatsComment < Avo::BaseResource
  self.includes = []
  self.model_class = ::Retreats::Comment
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :retreat, as: :belongs_to
    field :name, as: :text
    field :user, as: :belongs_to
  end
end
