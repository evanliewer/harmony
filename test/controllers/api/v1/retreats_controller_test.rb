require "controllers/api/v1/test"

class Api::V1::RetreatsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @retreat = build(:retreat, team: @team)
    @other_retreats = create_list(:retreat, 3)

    @another_retreat = create(:retreat, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @retreat.save
    @another_retreat.save

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
  def assert_proper_object_serialization(retreat_data)
    # Fetch the retreat in question and prepare to compare it's attributes.
    retreat = Retreat.find(retreat_data["id"])

    assert_equal_or_nil retreat_data['name'], retreat.name
    assert_equal_or_nil retreat_data['description'], retreat.description
    assert_equal_or_nil DateTime.parse(retreat_data['arrival']), retreat.arrival
    assert_equal_or_nil DateTime.parse(retreat_data['departure']), retreat.departure
    assert_equal_or_nil retreat_data['guest_count'], retreat.guest_count
    assert_equal_or_nil retreat_data['organization_id'], retreat.organization_id
    assert_equal_or_nil retreat_data['internal'], retreat.internal
    assert_equal_or_nil retreat_data['active'], retreat.active
    assert_equal_or_nil retreat_data['jotform'], retreat.jotform
    assert_equal_or_nil retreat_data['location_ids'], retreat.location_ids
    assert_equal_or_nil retreat_data['demographic_ids'], retreat.demographic_ids
    assert_equal_or_nil retreat_data['planner_ids'], retreat.planner_ids
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal retreat_data["team_id"], retreat.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/retreats", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    retreat_ids_returned = response.parsed_body.map { |retreat| retreat["id"] }
    assert_includes(retreat_ids_returned, @retreat.id)

    # But not returning other people's resources.
    assert_not_includes(retreat_ids_returned, @other_retreats[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/retreats/#{@retreat.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/retreats/#{@retreat.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    retreat_data = JSON.parse(build(:retreat, team: nil).api_attributes.to_json)
    retreat_data.except!("id", "team_id", "created_at", "updated_at")
    params[:retreat] = retreat_data

    post "/api/v1/teams/#{@team.id}/retreats", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/retreats",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/retreats/#{@retreat.id}", params: {
      access_token: access_token,
      retreat: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        jotform: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @retreat.reload
    assert_equal @retreat.name, 'Alternative String Value'
    assert_equal @retreat.description, 'Alternative String Value'
    assert_equal @retreat.jotform, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/retreats/#{@retreat.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Retreat.count", -1) do
      delete "/api/v1/retreats/#{@retreat.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/retreats/#{@another_retreat.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
