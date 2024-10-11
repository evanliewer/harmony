require "controllers/api/v1/test"

class Api::V1::Flights::ChecksControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @check = build(:flights_check, team: @team)
    @other_checks = create_list(:flights_check, 3)

    @another_check = create(:flights_check, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @check.save
    @another_check.save

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
  def assert_proper_object_serialization(check_data)
    # Fetch the check in question and prepare to compare it's attributes.
    check = Flights::Check.find(check_data["id"])

    assert_equal_or_nil check_data['name'], check.name
    assert_equal_or_nil check_data['retreat_id'], check.retreat_id
    assert_equal_or_nil check_data['flight_id'], check.flight_id
    assert_equal_or_nil check_data['user_id'], check.user_id
    assert_equal_or_nil DateTime.parse(check_data['completed_at']), check.completed_at
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal check_data["team_id"], check.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/flights/checks", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    check_ids_returned = response.parsed_body.map { |check| check["id"] }
    assert_includes(check_ids_returned, @check.id)

    # But not returning other people's resources.
    assert_not_includes(check_ids_returned, @other_checks[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/flights/checks/#{@check.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/flights/checks/#{@check.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    check_data = JSON.parse(build(:flights_check, team: nil).api_attributes.to_json)
    check_data.except!("id", "team_id", "created_at", "updated_at")
    params[:flights_check] = check_data

    post "/api/v1/teams/#{@team.id}/flights/checks", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/flights/checks",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/flights/checks/#{@check.id}", params: {
      access_token: access_token,
      flights_check: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @check.reload
    assert_equal @check.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/flights/checks/#{@check.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Flights::Check.count", -1) do
      delete "/api/v1/flights/checks/#{@check.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/flights/checks/#{@another_check.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
