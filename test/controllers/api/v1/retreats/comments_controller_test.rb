require "controllers/api/v1/test"

class Api::V1::Retreats::CommentsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @retreat = create(:retreat, team: @team)
    @comment = build(:retreats_comment, retreat: @retreat)
    @other_comments = create_list(:retreats_comment, 3)

    @another_comment = create(:retreats_comment, retreat: @retreat)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @comment.save
    @another_comment.save

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
  def assert_proper_object_serialization(comment_data)
    # Fetch the comment in question and prepare to compare it's attributes.
    comment = Retreats::Comment.find(comment_data["id"])

    assert_equal_or_nil comment_data['name'], comment.name
    assert_equal_or_nil comment_data['user_id'], comment.user_id
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal comment_data["retreat_id"], comment.retreat_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/retreats/#{@retreat.id}/comments", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    comment_ids_returned = response.parsed_body.map { |comment| comment["id"] }
    assert_includes(comment_ids_returned, @comment.id)

    # But not returning other people's resources.
    assert_not_includes(comment_ids_returned, @other_comments[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/retreats/comments/#{@comment.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/retreats/comments/#{@comment.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    comment_data = JSON.parse(build(:retreats_comment, retreat: nil).api_attributes.to_json)
    comment_data.except!("id", "retreat_id", "created_at", "updated_at")
    params[:retreats_comment] = comment_data

    post "/api/v1/retreats/#{@retreat.id}/comments", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/retreats/#{@retreat.id}/comments",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/retreats/comments/#{@comment.id}", params: {
      access_token: access_token,
      retreats_comment: {
        name: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @comment.reload
    assert_equal @comment.name, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/retreats/comments/#{@comment.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Retreats::Comment.count", -1) do
      delete "/api/v1/retreats/comments/#{@comment.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/retreats/comments/#{@another_comment.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
