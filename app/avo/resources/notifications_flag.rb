class Avo::Resources::NotificationsFlag < Avo::BaseResource
  self.includes = []
  self.model_class = ::Notifications::Flag
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :department, as: :belongs_to
  end
end
