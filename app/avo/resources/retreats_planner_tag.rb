class Avo::Resources::RetreatsPlannerTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Retreats::PlannerTag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :retreat, as: :belongs_to
    field :planner, as: :belongs_to
  end
end
