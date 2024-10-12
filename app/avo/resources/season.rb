class Avo::Resources::Season < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :item, as: :belongs_to
    field :season_start, as: :date_time
    field :season_end, as: :date_time
    field :start_time, as: :date_time
    field :end_time, as: :date_time
    field :quantity, as: :number
    field :notes, as: :text
  end
end
