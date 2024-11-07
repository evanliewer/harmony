class Webhooks::Incoming::JotformWebhooksController < Webhooks::Incoming::WebhooksController
  def create
   # Webhooks::Incoming::JotformWebhook.create(data: JSON.parse(request.raw_post)).process_async
   
      if request.content_type == 'application/json'
        data = JSON.parse(request.raw_post)
      else
        # Use params directly for form-data
        data = params.to_unsafe_h # Converts ActionController::Parameters to a hash if necessary
      end

      Webhooks::Incoming::JotformWebhook.create(data: data).process_async
      render json: { message: "Webhook received successfully" }, status: :created
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parsing failed: #{e.message}")
      render json: { error: "Invalid JSON format" }, status: :unprocessable_entity



  #  render json: {status: "OK"}, status: :created
  end
end
