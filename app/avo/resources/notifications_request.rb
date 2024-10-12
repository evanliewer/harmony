class Avo::Resources::NotificationsRequest < Avo::BaseResource
  self.includes = []
  self.model_class = ::Notifications::Request
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :user, as: :belongs_to
    field :notifications_flag, as: :belongs_to
    field :days_before, as: :text
    field :email, as: :text
  end
end
