class Account::QuestionsController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :question, through: :team, through_association: :questions

  # GET /account/teams/:team_id/questions
  # GET /account/teams/:team_id/questions.json
  def index
    delegate_json_to_api
  end

  # GET /account/questions/:id
  # GET /account/questions/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/questions/new
  def new
  end

  # GET /account/questions/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/questions
  # POST /account/teams/:team_id/questions.json
  def create
    respond_to do |format|
      if @question.save
        format.html { redirect_to [:account, @question], notice: I18n.t("questions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @question] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/questions/:id
  # PATCH/PUT /account/questions/:id.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to [:account, @question], notice: I18n.t("questions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @question] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/questions/:id
  # DELETE /account/questions/:id.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :questions], notice: I18n.t("questions.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_select_options(strong_params, :location_ids)
    assign_select_options(strong_params, :demographic_ids)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
