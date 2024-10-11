require "controllers/api/v1/test"

class Api::V1::Flights::TimeframesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @timeframe = build(:flights_timeframe, team: @team)
    @other_timeframes = create_list(:flights_timeframe, 3)

    @another_timeframe = create(:flights_timeframe, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @timeframe.save
    @another_timeframe.save

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
  def assert_proper_object_serialization(timeframe_data)
    # Fetch the timeframe in question and prepare to compare it's attributes.
    timeframe = Flights::Timeframe.find(timeframe_data["id"])

    assert_equal_or_nil timeframe_data['name'], timeframe.name
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal timeframe_data["team_id"], timeframe.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/flights/timeframes", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    timeframe_ids_returned = response.parsed_body.map { |timeframe| timeframe["id"] }
    assert_includes(timeframe_ids_returned, @timeframe.id)

    # But not returning other people's resources.
    assert_not_includes(timeframe_ids_returned, @other_timeframes[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/flights/timeframes/#{@timeframe.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/flights/timeframes/#{@timeframe.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    timeframe_data = JSON.parse(build(:flights_timeframe, team: nil).api_attributes.to_json)
    timeframe_data.except!("id", "team_id", "created_at", "updated_at")
    params[:flights_timeframe] = timeframe_data

    post "/api/v1/teams/#{@team.id}/flights/timeframes", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/flights/timeframes",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/flights/timeframes/#{@timeframe.id}", params: {
      access_token: access_token,
      flights_timeframe: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @timeframe.reload
    assert_equal @timeframe.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/flights/timeframes/#{@timeframe.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Flights::Timeframe.count", -1) do
      delete "/api/v1/flights/timeframes/#{@timeframe.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/flights/timeframes/#{@another_timeframe.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
