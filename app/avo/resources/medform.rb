class Avo::Resources::Medform < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :retreat, as: :belongs_to
    field :phone, as: :text
    field :email, as: :text
    field :dietary, as: :text
  end
end
