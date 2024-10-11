class Avo::Resources::Location < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :initials, as: :text
    field :capacity, as: :number
    field :hex_color, as: :text
    field :active, as: :text
  end
end
