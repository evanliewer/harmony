require "controllers/api/v1/test"

class Api::V1::QuestionsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @question = build(:question, team: @team)
    @other_questions = create_list(:question, 3)

    @another_question = create(:question, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @question.save
    @another_question.save

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
  def assert_proper_object_serialization(question_data)
    # Fetch the question in question and prepare to compare it's attributes.
    question = Question.find(question_data["id"])

    assert_equal_or_nil question_data['name'], question.name
    assert_equal_or_nil question_data['description'], question.description
    assert_equal_or_nil question_data['location_ids'], question.location_ids
    assert_equal_or_nil question_data['demographic_ids'], question.demographic_ids
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal question_data["team_id"], question.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/questions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    question_ids_returned = response.parsed_body.map { |question| question["id"] }
    assert_includes(question_ids_returned, @question.id)

    # But not returning other people's resources.
    assert_not_includes(question_ids_returned, @other_questions[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/questions/#{@question.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/questions/#{@question.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    question_data = JSON.parse(build(:question, team: nil).api_attributes.to_json)
    question_data.except!("id", "team_id", "created_at", "updated_at")
    params[:question] = question_data

    post "/api/v1/teams/#{@team.id}/questions", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/questions",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/questions/#{@question.id}", params: {
      access_token: access_token,
      question: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @question.reload
    assert_equal @question.name, 'Alternative String Value'
    assert_equal @question.description, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/questions/#{@question.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Question.count", -1) do
      delete "/api/v1/questions/#{@question.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/questions/#{@another_question.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
