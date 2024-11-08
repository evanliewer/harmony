class Account::DietsController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :diet, through: :team, through_association: :diets

  # GET /account/teams/:team_id/diets
  # GET /account/teams/:team_id/diets.json
  def index
    delegate_json_to_api
  end

  # GET /account/diets/:id
  # GET /account/diets/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/diets/new
  def new
  end

  # GET /account/diets/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/diets
  # POST /account/teams/:team_id/diets.json
  def create
    respond_to do |format|
      if @diet.save
        format.html { redirect_to [:account, @diet], notice: I18n.t("diets.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @diet] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @diet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/diets/:id
  # PATCH/PUT /account/diets/:id.json
  def update
    respond_to do |format|
      if @diet.update(diet_params)
        format.html { redirect_to [:account, @diet], notice: I18n.t("diets.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @diet] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @diet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/diets/:id
  # DELETE /account/diets/:id.json
  def destroy
    @diet.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :diets], notice: I18n.t("diets.notifications.destroyed") }
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
