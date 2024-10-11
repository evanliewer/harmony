require "controllers/api/v1/test"

class Api::V1::FlightsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @flight = build(:flight, team: @team)
    @other_flights = create_list(:flight, 3)

    @another_flight = create(:flight, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @flight.save
    @another_flight.save

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
  def assert_proper_object_serialization(flight_data)
    # Fetch the flight in question and prepare to compare it's attributes.
    flight = Flight.find(flight_data["id"])

    assert_equal_or_nil flight_data['name'], flight.name
    assert_equal_or_nil flight_data['description'], flight.description
    assert_equal_or_nil flight_data['external'], flight.external
    assert_equal_or_nil flight_data['preflight'], flight.preflight
    assert_equal_or_nil flight_data['warning'], flight.warning
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal flight_data["team_id"], flight.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/flights", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    flight_ids_returned = response.parsed_body.map { |flight| flight["id"] }
    assert_includes(flight_ids_returned, @flight.id)

    # But not returning other people's resources.
    assert_not_includes(flight_ids_returned, @other_flights[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/flights/#{@flight.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/flights/#{@flight.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    flight_data = JSON.parse(build(:flight, team: nil).api_attributes.to_json)
    flight_data.except!("id", "team_id", "created_at", "updated_at")
    params[:flight] = flight_data

    post "/api/v1/teams/#{@team.id}/flights", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/flights",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/flights/#{@flight.id}", params: {
      access_token: access_token,
      flight: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @flight.reload
    assert_equal @flight.name, 'Alternative String Value'
    assert_equal @flight.description, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/flights/#{@flight.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Flight.count", -1) do
      delete "/api/v1/flights/#{@flight.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/flights/#{@another_flight.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
