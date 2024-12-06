require "controllers/api/v1/test"

class Api::V1::Notifications::ArchiveActionsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @another_user = create(:onboarded_user)
    @notifications = create_list(:notification, 3, team: @team)
    @other_notifications = create_list(:notification, 3, team: @another_user.current_team)

    @notifications_archive_action =
      create(:notifications_archive_action,
        team: @team,
        created_by: @user.memberships.first,
        target_ids: [@notifications.first.id.to_s])
    @other_notifications_archive_actions =
      create_list(:notifications_archive_action, 3,
        team: @another_user.current_team,
        created_by: @another_user.memberships.first,
        target_ids: [@notifications.first.id.to_s])
  end

  def assert_proper_object_serialization(notifications_archive_action_data)
    notifications_archive_action = Notifications::ArchiveAction.find(notifications_archive_action_data["id"])

    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal notifications_archive_action_data["team_id"], notifications_archive_action.team_id
  end

  test "index" do
    get "/api/v1/teams/#{@team.id}/notifications/archive_actions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    notifications_archive_action_ids_returned = response.parsed_body.map { |notifications_archive_action| notifications_archive_action["id"] }
    assert_includes(notifications_archive_action_ids_returned, @notifications_archive_action.id)

    # But not returning other people's resources.
    assert_not_includes(notifications_archive_action_ids_returned, @other_notifications_archive_actions.first.id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    get "/api/v1/notifications/archive_actions/#{@notifications_archive_action.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/notifications/archive_actions/#{@notifications_archive_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    params = {access_token: access_token}
    archive_actions_data = JSON.parse(build(:notifications_archive_action, team: nil, target_ids: [@notifications.first.id.to_s], created_by: @user.memberships.first).to_json)
    archive_actions_data = archive_actions_data.slice("target_all", "scheduled_for", "target_ids", "created_by_id")
    params[:notifications_archive_action] = archive_actions_data

    post "/api/v1/teams/#{@team.id}/notifications/archive_actions", params: params
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body
    post "/api/v1/teams/#{@team.id}/notifications/archive_actions",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    refute @notifications_archive_action.target_all

    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/notifications/archive_actions/#{@notifications_archive_action.id}", params: {
      access_token: access_token,
      notifications_archive_action: {
        target_all: true
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @notifications_archive_action.reload
    assert @notifications_archive_action.target_all

    # Also ensure we can't do that same action as another user.
    put "/api/v1/notifications/archive_actions/#{@notifications_archive_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Notifications::ArchiveAction.count", -1) do
      delete "/api/v1/notifications/archive_actions/#{@notifications_archive_action.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/notifications/archive_actions/#{@notifications_archive_action.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
