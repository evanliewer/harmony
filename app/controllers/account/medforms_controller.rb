class Account::MedformsController < Account::ApplicationController
  before_action :set_default_address, except: :index
  account_load_and_authorize_resource :medform, through: :team, through_association: :medforms

  # GET /account/teams/:team_id/medforms
  # GET /account/teams/:team_id/medforms.json
  def index
    if params[:retreat_id].present?
      @medforms = Medform.where(retreat_id: params[:retreat_id])
      @retreat = Retreat.find(params[:retreat_id])
    else 
      @medforms = Medform.all
    end    
    delegate_json_to_api
  end

  # GET /account/medforms/:id
  # GET /account/medforms/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/medforms/new
  def new
  end

  # GET /account/medforms/:id/edit
  def edit
  end


  # POST /account/teams/:team_id/medforms
  # POST /account/teams/:team_id/medforms.json
  def create
    respond_to do |format|
      if @medform.save
        #format.html { redirect_to [:account, @medform], notice: I18n.t("medforms.notifications.created") }
        format.html { redirect_to thank_you_path, notice: I18n.t("medforms.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @medform] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medform.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/medforms/:id
  # PATCH/PUT /account/medforms/:id.json
  def update
    respond_to do |format|
      if @medform.update(medform_params)
        format.html { redirect_to [:account, @medform], notice: I18n.t("medforms.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @medform] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medform.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/medforms/:id
  # DELETE /account/medforms/:id.json
  def destroy
    @medform.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :medforms], notice: I18n.t("medforms.notifications.destroyed") }
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

  def set_default_address
    @medform.address ||= Address.new
  end
end
