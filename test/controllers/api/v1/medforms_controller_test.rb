require "controllers/api/v1/test"

class Api::V1::MedformsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @medform = build(:medform, team: @team)
    @other_medforms = create_list(:medform, 3)

    @another_medform = create(:medform, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @medform.save
    @another_medform.save

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
  def assert_proper_object_serialization(medform_data)
    # Fetch the medform in question and prepare to compare it's attributes.
    medform = Medform.find(medform_data["id"])

    assert_equal_or_nil medform_data['name'], medform.name
    assert_equal_or_nil medform_data['retreat_id'], medform.retreat_id
    assert_equal_or_nil medform_data['phone'], medform.phone
    assert_equal_or_nil medform_data['email'], medform.email
    assert_equal_or_nil medform_data['dietary'], medform.dietary
    assert_equal_or_nil medform_data['diet_id'], medform.diet_id
    assert_equal_or_nil medform_data['gender'], medform.gender
    assert_equal_or_nil medform_data['address'], medform.address
    assert_equal_or_nil medform_data['emergency_contact_name'], medform.emergency_contact_name
    assert_equal_or_nil medform_data['emergency_contact_phone'], medform.emergency_contact_phone
    assert_equal_or_nil medform_data['emergency_contact_relationship'], medform.emergency_contact_relationship
    assert_equal_or_nil medform_data['terms'], medform.terms
    assert_equal_or_nil medform_data['form_for'], medform.form_for
    assert_equal_or_nil medform_data['age'], medform.age
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal medform_data["team_id"], medform.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/medforms", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    medform_ids_returned = response.parsed_body.map { |medform| medform["id"] }
    assert_includes(medform_ids_returned, @medform.id)

    # But not returning other people's resources.
    assert_not_includes(medform_ids_returned, @other_medforms[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/medforms/#{@medform.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/medforms/#{@medform.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    medform_data = JSON.parse(build(:medform, team: nil).api_attributes.to_json)
    medform_data.except!("id", "team_id", "created_at", "updated_at")
    params[:medform] = medform_data

    post "/api/v1/teams/#{@team.id}/medforms", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/medforms",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/medforms/#{@medform.id}", params: {
      access_token: access_token,
      medform: {
        name: 'Alternative String Value',
        phone: 'Alternative String Value',
        email: 'Alternative String Value',
        dietary: 'Alternative String Value',
        gender: 'Alternative String Value',
        emergency_contact_name: 'Alternative String Value',
        emergency_contact_phone: 'Alternative String Value',
        emergency_contact_relationship: 'Alternative String Value',
        form_for: 'Alternative String Value',
        age: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @medform.reload
    assert_equal @medform.name, 'Alternative String Value'
    assert_equal @medform.phone, 'Alternative String Value'
    assert_equal @medform.email, 'Alternative String Value'
    assert_equal @medform.dietary, 'Alternative String Value'
    assert_equal @medform.gender, 'Alternative String Value'
    assert_equal @medform.emergency_contact_name, 'Alternative String Value'
    assert_equal @medform.emergency_contact_phone, 'Alternative String Value'
    assert_equal @medform.emergency_contact_relationship, 'Alternative String Value'
    assert_equal @medform.form_for, 'Alternative String Value'
    assert_equal @medform.age, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/medforms/#{@medform.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Medform.count", -1) do
      delete "/api/v1/medforms/#{@medform.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/medforms/#{@another_medform.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
