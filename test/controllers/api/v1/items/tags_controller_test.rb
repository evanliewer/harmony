require "controllers/api/v1/test"

class Api::V1::Items::TagsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @tag = build(:items_tag, team: @team)
    @other_tags = create_list(:items_tag, 3)

    @another_tag = create(:items_tag, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @tag.save
    @another_tag.save

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
  def assert_proper_object_serialization(tag_data)
    # Fetch the tag in question and prepare to compare it's attributes.
    tag = Items::Tag.find(tag_data["id"])

    assert_equal_or_nil tag_data['name'], tag.name
    assert_equal_or_nil tag_data['ticketable'], tag.ticketable
    assert_equal_or_nil tag_data['schedulable'], tag.schedulable
    assert_equal_or_nil tag_data['optionable'], tag.optionable
    assert_equal_or_nil tag_data['exclusivable'], tag.exclusivable
    assert_equal_or_nil tag_data['cleanable'], tag.cleanable
    assert_equal_or_nil tag_data['publicable'], tag.publicable
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal tag_data["team_id"], tag.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/items/tags", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    tag_ids_returned = response.parsed_body.map { |tag| tag["id"] }
    assert_includes(tag_ids_returned, @tag.id)

    # But not returning other people's resources.
    assert_not_includes(tag_ids_returned, @other_tags[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/items/tags/#{@tag.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/items/tags/#{@tag.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    tag_data = JSON.parse(build(:items_tag, team: nil).api_attributes.to_json)
    tag_data.except!("id", "team_id", "created_at", "updated_at")
    params[:items_tag] = tag_data

    post "/api/v1/teams/#{@team.id}/items/tags", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/items/tags",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/items/tags/#{@tag.id}", params: {
      access_token: access_token,
      items_tag: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @tag.reload
    assert_equal @tag.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/items/tags/#{@tag.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Items::Tag.count", -1) do
      delete "/api/v1/items/tags/#{@tag.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/items/tags/#{@another_tag.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
