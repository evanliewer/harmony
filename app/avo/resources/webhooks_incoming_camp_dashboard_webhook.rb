class Avo::Resources::WebhooksIncomingCampDashboardWebhook < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Webhooks::Incoming::CampDashboardWebhook
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :data, as: :text
    field :processed_at, as: :date_time
    field :verified_at, as: :date_time
  end
end
