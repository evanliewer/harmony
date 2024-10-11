require "controllers/api/v1/test"

class Api::V1::ReservationsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @reservation = build(:reservation, team: @team)
    @other_reservations = create_list(:reservation, 3)

    @another_reservation = create(:reservation, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @reservation.save
    @another_reservation.save

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
  def assert_proper_object_serialization(reservation_data)
    # Fetch the reservation in question and prepare to compare it's attributes.
    reservation = Reservation.find(reservation_data["id"])

    assert_equal_or_nil reservation_data['name'], reservation.name
    assert_equal_or_nil reservation_data['retreat_id'], reservation.retreat_id
    assert_equal_or_nil reservation_data['item_id'], reservation.item_id
    assert_equal_or_nil reservation_data['user_id'], reservation.user_id
    assert_equal_or_nil DateTime.parse(reservation_data['start_time']), reservation.start_time
    assert_equal_or_nil DateTime.parse(reservation_data['end_time']), reservation.end_time
    assert_equal_or_nil reservation_data['quantity'], reservation.quantity
    assert_equal_or_nil reservation_data['notes'], reservation.notes
    assert_equal_or_nil reservation_data['seasonal_default'], reservation.seasonal_default
    assert_equal_or_nil reservation_data['exclusive'], reservation.exclusive
    assert_equal_or_nil reservation_data['active'], reservation.active
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal reservation_data["team_id"], reservation.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/reservations", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    reservation_ids_returned = response.parsed_body.map { |reservation| reservation["id"] }
    assert_includes(reservation_ids_returned, @reservation.id)

    # But not returning other people's resources.
    assert_not_includes(reservation_ids_returned, @other_reservations[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/reservations/#{@reservation.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/reservations/#{@reservation.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    reservation_data = JSON.parse(build(:reservation, team: nil).api_attributes.to_json)
    reservation_data.except!("id", "team_id", "created_at", "updated_at")
    params[:reservation] = reservation_data

    post "/api/v1/teams/#{@team.id}/reservations", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/reservations",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/reservations/#{@reservation.id}", params: {
      access_token: access_token,
      reservation: {
        name: 'Alternative String Value',
        notes: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @reservation.reload
    assert_equal @reservation.name, 'Alternative String Value'
    assert_equal @reservation.notes, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/reservations/#{@reservation.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Reservation.count", -1) do
      delete "/api/v1/reservations/#{@reservation.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/reservations/#{@another_reservation.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
