# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::Organizations::ContactsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :contact, through: :team, through_association: :organizations_contacts

    # GET /api/v1/teams/:team_id/organizations/contacts
    def index
    end

    # GET /api/v1/organizations/contacts/:id
    def show
    end

    # POST /api/v1/teams/:team_id/organizations/contacts
    def create
      if @contact.save
        render :show, status: :created, location: [:api, :v1, @contact]
      else
        render json: @contact.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/organizations/contacts/:id
    def update
      if @contact.update(contact_params)
        render :show
      else
        render json: @contact.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/organizations/contacts/:id
    def destroy
      @contact.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def contact_params
        strong_params = params.require(:organizations_contact).permit(
          *permitted_fields,
          :first_name,
          :last_name,
          :job_title,
          :primary_phone,
          :email,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::Organizations::ContactsController
  end
end
