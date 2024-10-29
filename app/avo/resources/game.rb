class Avo::Resources::Game < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :red_score, as: :text
    field :blue_score, as: :text
    field :yellow_score, as: :text
    field :green_score, as: :text
  end
end
