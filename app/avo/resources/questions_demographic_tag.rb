class Avo::Resources::QuestionsDemographicTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Questions::DemographicTag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :question, as: :belongs_to
    field :demographic, as: :belongs_to
  end
end
