require "controllers/api/v1/test"

class Api::V1::LocationsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @location = build(:location, team: @team)
    @other_locations = create_list(:location, 3)

    @another_location = create(:location, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @location.save
    @another_location.save

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
  def assert_proper_object_serialization(location_data)
    # Fetch the location in question and prepare to compare it's attributes.
    location = Location.find(location_data["id"])

    assert_equal_or_nil location_data['name'], location.name
    assert_equal_or_nil location_data['initials'], location.initials
    assert_equal_or_nil location_data['capacity'], location.capacity
    assert_equal_or_nil location_data['hex_color'], location.hex_color
    assert_equal_or_nil location_data['active'], location.active
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal location_data["team_id"], location.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/locations", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    location_ids_returned = response.parsed_body.map { |location| location["id"] }
    assert_includes(location_ids_returned, @location.id)

    # But not returning other people's resources.
    assert_not_includes(location_ids_returned, @other_locations[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/locations/#{@location.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/locations/#{@location.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    location_data = JSON.parse(build(:location, team: nil).api_attributes.to_json)
    location_data.except!("id", "team_id", "created_at", "updated_at")
    params[:location] = location_data

    post "/api/v1/teams/#{@team.id}/locations", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/locations",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/locations/#{@location.id}", params: {
      access_token: access_token,
      location: {
        name: 'Alternative String Value',
        initials: 'Alternative String Value',
        hex_color: '#47E37F',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @location.reload
    assert_equal @location.name, 'Alternative String Value'
    assert_equal @location.initials, 'Alternative String Value'
    assert_equal @location.hex_color, '#47E37F'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/locations/#{@location.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Location.count", -1) do
      delete "/api/v1/locations/#{@location.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/locations/#{@another_location.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
