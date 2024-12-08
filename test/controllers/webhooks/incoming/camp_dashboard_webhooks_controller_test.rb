require "test_helper"

class Webhooks::Incoming::CampDashboardWebhooksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = FactoryBot.create(:onboarded_user)
    @membership = @user.memberships.first
    @team = @user.current_team
  end

  test "should get incoming webhook" do
    webhook_params = {
      data: {
        data: {
          name: "Test",
          team_id: {
            id: @team.id,
            slug: nil,
            locale: nil,
            time_zone: @team.time_zone,
            created_at: @membership.created_at,
            updated_at: @membership.updated_at,
            being_destroyed: nil,
          },
          description: ""
        },
        event_type: "membership.created",
        subject_type: "Membership"
      },
      verified_at: nil,
      processed_at: nil,
    }

    post "/webhooks/incoming/camp_dashboard_webhooks", params: webhook_params.to_json
    assert_equal response.parsed_body, {"status" => "OK"}

    webhook = Webhooks::Incoming::CampDashboardWebhook.first
    assert_equal webhook.data.to_json, webhook_params.to_json
  end
end
