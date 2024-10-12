class Account::WebsiteimagesController < Account::ApplicationController
  account_load_and_authorize_resource :websiteimage, through: :team, through_association: :websiteimages

  # GET /account/teams/:team_id/websiteimages
  # GET /account/teams/:team_id/websiteimages.json
  def index
    delegate_json_to_api
  end

  # GET /account/websiteimages/:id
  # GET /account/websiteimages/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/websiteimages/new
  def new
  end

  # GET /account/websiteimages/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/websiteimages
  # POST /account/teams/:team_id/websiteimages.json
  def create
    respond_to do |format|
      if @websiteimage.save
        format.html { redirect_to [:account, @websiteimage], notice: I18n.t("websiteimages.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @websiteimage] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @websiteimage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/websiteimages/:id
  # PATCH/PUT /account/websiteimages/:id.json
  def update
    respond_to do |format|
      if @websiteimage.update(websiteimage_params)
        format.html { redirect_to [:account, @websiteimage], notice: I18n.t("websiteimages.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @websiteimage] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @websiteimage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/websiteimages/:id
  # DELETE /account/websiteimages/:id.json
  def destroy
    @websiteimage.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :websiteimages], notice: I18n.t("websiteimages.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
