class Avo::Resources::Retreat < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :description, as: :textarea
    field :arrival, as: :date_time
    field :departure, as: :date_time
    field :guest_count, as: :number
    field :organization, as: :belongs_to
    field :internal, as: :boolean
    field :active, as: :boolean
    field :jotform, as: :text
  end
end
