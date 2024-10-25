require "controllers/api/v1/test"

class Api::V1::Items::AreasControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @area = build(:items_area, team: @team)
    @other_areas = create_list(:items_area, 3)

    @another_area = create(:items_area, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @area.save
    @another_area.save

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
  def assert_proper_object_serialization(area_data)
    # Fetch the area in question and prepare to compare it's attributes.
    area = Items::Area.find(area_data["id"])

    assert_equal_or_nil area_data['name'], area.name
    assert_equal_or_nil area_data['location_id'], area.location_id
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal area_data["team_id"], area.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/items/areas", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    area_ids_returned = response.parsed_body.map { |area| area["id"] }
    assert_includes(area_ids_returned, @area.id)

    # But not returning other people's resources.
    assert_not_includes(area_ids_returned, @other_areas[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/items/areas/#{@area.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/items/areas/#{@area.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    area_data = JSON.parse(build(:items_area, team: nil).api_attributes.to_json)
    area_data.except!("id", "team_id", "created_at", "updated_at")
    params[:items_area] = area_data

    post "/api/v1/teams/#{@team.id}/items/areas", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/items/areas",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/items/areas/#{@area.id}", params: {
      access_token: access_token,
      items_area: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @area.reload
    assert_equal @area.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/items/areas/#{@area.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Items::Area.count", -1) do
      delete "/api/v1/items/areas/#{@area.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/items/areas/#{@another_area.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
