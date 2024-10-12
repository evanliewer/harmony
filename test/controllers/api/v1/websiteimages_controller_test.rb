require "controllers/api/v1/test"

class Api::V1::WebsiteimagesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @websiteimage = build(:websiteimage, team: @team)
    @other_websiteimages = create_list(:websiteimage, 3)

    @another_websiteimage = create(:websiteimage, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @websiteimage.save
    @another_websiteimage.save

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
  def assert_proper_object_serialization(websiteimage_data)
    # Fetch the websiteimage in question and prepare to compare it's attributes.
    websiteimage = Websiteimage.find(websiteimage_data["id"])

    assert_equal_or_nil websiteimage_data['name'], websiteimage.name
    assert_equal_or_nil websiteimage_data['description'], websiteimage.description
    assert_equal_or_nil websiteimage_data['image'], websiteimage.image
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal websiteimage_data["team_id"], websiteimage.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/websiteimages", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    websiteimage_ids_returned = response.parsed_body.map { |websiteimage| websiteimage["id"] }
    assert_includes(websiteimage_ids_returned, @websiteimage.id)

    # But not returning other people's resources.
    assert_not_includes(websiteimage_ids_returned, @other_websiteimages[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/websiteimages/#{@websiteimage.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/websiteimages/#{@websiteimage.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    websiteimage_data = JSON.parse(build(:websiteimage, team: nil).api_attributes.to_json)
    websiteimage_data.except!("id", "team_id", "created_at", "updated_at")
    params[:websiteimage] = websiteimage_data

    post "/api/v1/teams/#{@team.id}/websiteimages", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/websiteimages",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/websiteimages/#{@websiteimage.id}", params: {
      access_token: access_token,
      websiteimage: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @websiteimage.reload
    assert_equal @websiteimage.name, 'Alternative String Value'
    assert_equal @websiteimage.description, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/websiteimages/#{@websiteimage.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Websiteimage.count", -1) do
      delete "/api/v1/websiteimages/#{@websiteimage.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/websiteimages/#{@another_websiteimage.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
