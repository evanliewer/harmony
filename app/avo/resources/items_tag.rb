class Avo::Resources::ItemsTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Items::Tag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :ticketable, as: :boolean
    field :schedulable, as: :boolean
    field :optionable, as: :boolean
    field :exclusivable, as: :boolean
    field :cleanable, as: :boolean
    field :publicable, as: :boolean
  end
end
