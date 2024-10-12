class Avo::Resources::RetreatsAssignedContact < Avo::BaseResource
  self.includes = []
  self.model_class = ::Retreats::AssignedContact
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :retreat, as: :belongs_to
    field :contact, as: :belongs_to
  end
end
