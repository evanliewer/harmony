class Avo::Resources::ItemsOption < Avo::BaseResource
  self.includes = []
  self.model_class = ::Items::Option
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :item, as: :belongs_to
    field :name, as: :text
    field :capacity, as: :number
    field :image_tag, as: :text
  end
end
