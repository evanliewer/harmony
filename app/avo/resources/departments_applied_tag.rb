class Avo::Resources::DepartmentsAppliedTag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Departments::AppliedTag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :department, as: :belongs_to
    field :tag, as: :belongs_to
  end
end
