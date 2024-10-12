require "controllers/api/v1/test"

class Api::V1::NotificationsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @notification = build(:notification, team: @team)
    @other_notifications = create_list(:notification, 3)

    @another_notification = create(:notification, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @notification.save
    @another_notification.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  def teardown
    super
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(notification_data)
    # Fetch the notification in question and prepare to compare it's attributes.
    notification = Notification.find(notification_data["id"])

    assert_equal_or_nil notification_data['name'], notification.name
    assert_equal_or_nil notification_data['user_id'], notification.user_id
    assert_equal_or_nil DateTime.parse(notification_data['read_at']), notification.read_at
    assert_equal_or_nil notification_data['action_text'], notification.action_text
    assert_equal_or_nil notification_data['emailed'], notification.emailed
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal notification_data["team_id"], notification.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/notifications", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    notification_ids_returned = response.parsed_body.map { |notification| notification["id"] }
    assert_includes(notification_ids_returned, @notification.id)

    # But not returning other people's resources.
    assert_not_includes(notification_ids_returned, @other_notifications[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/notifications/#{@notification.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/notifications/#{@notification.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    notification_data = JSON.parse(build(:notification, team: nil).api_attributes.to_json)
    notification_data.except!("id", "team_id", "created_at", "updated_at")
    params[:notification] = notification_data

    post "/api/v1/teams/#{@team.id}/notifications", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/notifications",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/notifications/#{@notification.id}", params: {
      access_token: access_token,
      notification: {
        name: 'Alternative String Value',
        action_text: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @notification.reload
    assert_equal @notification.name, 'Alternative String Value'
    assert_equal @notification.action_text, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/notifications/#{@notification.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Notification.count", -1) do
      delete "/api/v1/notifications/#{@notification.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/notifications/#{@another_notification.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
