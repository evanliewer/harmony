class Avo::Resources::ItemsAppliedTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Items::AppliedTag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :item, as: :belongs_to
    field :tag, as: :belongs_to
  end
end
