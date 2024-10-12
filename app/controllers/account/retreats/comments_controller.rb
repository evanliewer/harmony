class Account::Retreats::CommentsController < Account::ApplicationController
  account_load_and_authorize_resource :comment, through: :retreat, through_association: :comments

  # GET /account/retreats/:retreat_id/comments
  # GET /account/retreats/:retreat_id/comments.json
  def index
    delegate_json_to_api
  end

  # GET /account/retreats/comments/:id
  # GET /account/retreats/comments/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/retreats/:retreat_id/comments/new
  def new
  end

  # GET /account/retreats/comments/:id/edit
  def edit
  end

  # POST /account/retreats/:retreat_id/comments
  # POST /account/retreats/:retreat_id/comments.json
  def create
    respond_to do |format|
      if @comment.save
        format.html { redirect_to [:account, @comment], notice: I18n.t("retreats/comments.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @comment] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/retreats/comments/:id
  # PATCH/PUT /account/retreats/comments/:id.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to [:account, @comment], notice: I18n.t("retreats/comments.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @comment] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/retreats/comments/:id
  # DELETE /account/retreats/comments/:id.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @retreat, :comments], notice: I18n.t("retreats/comments.notifications.destroyed") }
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
