require "controllers/api/v1/test"

class Api::V1::GamesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @game = build(:game, team: @team)
    @other_games = create_list(:game, 3)

    @another_game = create(:game, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @game.save
    @another_game.save

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
  def assert_proper_object_serialization(game_data)
    # Fetch the game in question and prepare to compare it's attributes.
    game = Game.find(game_data["id"])

    assert_equal_or_nil game_data['red_score'], game.red_score
    assert_equal_or_nil game_data['blue_score'], game.blue_score
    assert_equal_or_nil game_data['yellow_score'], game.yellow_score
    assert_equal_or_nil game_data['green_score'], game.green_score
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal game_data["team_id"], game.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/games", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    game_ids_returned = response.parsed_body.map { |game| game["id"] }
    assert_includes(game_ids_returned, @game.id)

    # But not returning other people's resources.
    assert_not_includes(game_ids_returned, @other_games[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/games/#{@game.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/games/#{@game.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    game_data = JSON.parse(build(:game, team: nil).api_attributes.to_json)
    game_data.except!("id", "team_id", "created_at", "updated_at")
    params[:game] = game_data

    post "/api/v1/teams/#{@team.id}/games", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/games",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/games/#{@game.id}", params: {
      access_token: access_token,
      game: {
        red_score: 'Alternative String Value',
        blue_score: 'Alternative String Value',
        yellow_score: 'Alternative String Value',
        green_score: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @game.reload
    assert_equal @game.red_score, 'Alternative String Value'
    assert_equal @game.blue_score, 'Alternative String Value'
    assert_equal @game.yellow_score, 'Alternative String Value'
    assert_equal @game.green_score, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/games/#{@game.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Game.count", -1) do
      delete "/api/v1/games/#{@game.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/games/#{@another_game.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
