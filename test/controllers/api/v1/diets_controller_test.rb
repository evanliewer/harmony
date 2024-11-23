require "controllers/api/v1/test"

class Api::V1::DietsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @diet = build(:diet, team: @team)
    @other_diets = create_list(:diet, 3)

    @another_diet = create(:diet, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @diet.save
    @another_diet.save

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
  def assert_proper_object_serialization(diet_data)
    # Fetch the diet in question and prepare to compare it's attributes.
    diet = Diet.find(diet_data["id"])

    assert_equal_or_nil diet_data['name'], diet.name
    assert_equal_or_nil diet_data['abbreviation'], diet.abbreviation
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal diet_data["team_id"], diet.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/diets", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    diet_ids_returned = response.parsed_body.map { |diet| diet["id"] }
    assert_includes(diet_ids_returned, @diet.id)

    # But not returning other people's resources.
    assert_not_includes(diet_ids_returned, @other_diets[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/diets/#{@diet.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/diets/#{@diet.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    diet_data = JSON.parse(build(:diet, team: nil).api_attributes.to_json)
    diet_data.except!("id", "team_id", "created_at", "updated_at")
    params[:diet] = diet_data

    post "/api/v1/teams/#{@team.id}/diets", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/diets",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/diets/#{@diet.id}", params: {
      access_token: access_token,
      diet: {
        name: 'Alternative String Value',
        abbreviation: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @diet.reload
    assert_equal @diet.name, 'Alternative String Value'
    assert_equal @diet.abbreviation, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/diets/#{@diet.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Diet.count", -1) do
      delete "/api/v1/diets/#{@diet.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/diets/#{@another_diet.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
