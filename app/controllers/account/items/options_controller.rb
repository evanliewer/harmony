class Account::Items::OptionsController < Account::ApplicationController
  include SortableActions
  account_load_and_authorize_resource :option, through: :item, through_association: :options

  # GET /account/items/:item_id/options
  # GET /account/items/:item_id/options.json
  def index
    delegate_json_to_api
  end

  # GET /account/items/options/:id
  # GET /account/items/options/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/items/:item_id/options/new
  def new
  end

  # GET /account/items/options/:id/edit
  def edit
  end

  # POST /account/items/:item_id/options
  # POST /account/items/:item_id/options.json
  def create
    respond_to do |format|
      if @option.save
        format.html { redirect_to [:account, @option], notice: I18n.t("items/options.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @option] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/items/options/:id
  # PATCH/PUT /account/items/options/:id.json
  def update
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to [:account, @option], notice: I18n.t("items/options.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @option] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/items/options/:id
  # DELETE /account/items/options/:id.json
  def destroy
    @option.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @item, :options], notice: I18n.t("items/options.notifications.destroyed") }
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
