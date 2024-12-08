class Webhooks::Incoming::CampDashboardWebhooksController < Webhooks::Incoming::WebhooksController
  def create
    Webhooks::Incoming::CampDashboardWebhook.create(data: JSON.parse(request.raw_post)).process_async
    render json: {status: "OK"}, status: :created
  end
end
