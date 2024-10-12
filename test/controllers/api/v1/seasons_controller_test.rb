require "controllers/api/v1/test"

class Api::V1::SeasonsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @season = build(:season, team: @team)
    @other_seasons = create_list(:season, 3)

    @another_season = create(:season, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @season.save
    @another_season.save

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
  def assert_proper_object_serialization(season_data)
    # Fetch the season in question and prepare to compare it's attributes.
    season = Season.find(season_data["id"])

    assert_equal_or_nil season_data['name'], season.name
    assert_equal_or_nil season_data['item_id'], season.item_id
    assert_equal_or_nil DateTime.parse(season_data['season_start']), season.season_start
    assert_equal_or_nil DateTime.parse(season_data['season_end']), season.season_end
    assert_equal_or_nil DateTime.parse(season_data['start_time']), season.start_time
    assert_equal_or_nil DateTime.parse(season_data['end_time']), season.end_time
    assert_equal_or_nil season_data['quantity'], season.quantity
    assert_equal_or_nil season_data['notes'], season.notes
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal season_data["team_id"], season.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/seasons", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    season_ids_returned = response.parsed_body.map { |season| season["id"] }
    assert_includes(season_ids_returned, @season.id)

    # But not returning other people's resources.
    assert_not_includes(season_ids_returned, @other_seasons[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/seasons/#{@season.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/seasons/#{@season.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    season_data = JSON.parse(build(:season, team: nil).api_attributes.to_json)
    season_data.except!("id", "team_id", "created_at", "updated_at")
    params[:season] = season_data

    post "/api/v1/teams/#{@team.id}/seasons", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/seasons",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/seasons/#{@season.id}", params: {
      access_token: access_token,
      season: {
        name: 'Alternative String Value',
        notes: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @season.reload
    assert_equal @season.name, 'Alternative String Value'
    assert_equal @season.notes, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/seasons/#{@season.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Season.count", -1) do
      delete "/api/v1/seasons/#{@season.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/seasons/#{@another_season.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
