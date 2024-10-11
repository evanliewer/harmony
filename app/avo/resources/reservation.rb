class Avo::Resources::Reservation < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :retreat, as: :belongs_to
    field :item, as: :belongs_to
    field :user, as: :belongs_to
    field :start_time, as: :date_time
    field :end_time, as: :date_time
    field :quantity, as: :number
    field :notes, as: :text
    field :seasonal_default, as: :boolean
    field :exclusive, as: :boolean
    field :active, as: :boolean
  end
end
