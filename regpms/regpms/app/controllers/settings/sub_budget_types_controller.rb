class Settings::SubBudgetTypesController < SettingsController
  load_and_authorize_resource :class => "SubBudgetType"

  before_action :set_sub_budget_type, only: [:show, :edit, :update, :destroy]

  # GET /sub_budget_types
  # GET /sub_budget_types.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = SubBudgetType.active_states.join(",")
    end if SubBudgetType.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if SubBudgetType.respond_to?(:workflow_spec)
    @q = SubBudgetType.limit(params[:limit]).search(params[:q])
    @q.sorts = 'no' if @q.sorts.empty?
    @sub_budget_types = request.format.html? ? @q.result.includes(:budget_type).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:budget_type)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /sub_budget_types/1
  # GET /sub_budget_types/1.json
  def show
  end

  # GET /sub_budget_types/new
  def new
    @sub_budget_type = SubBudgetType.new
    render layout: !request.xhr?

  end

  # GET /sub_budget_types/1/edit
  def edit
  end

  # POST /sub_budget_types
  # POST /sub_budget_types.json
  def create
    @sub_budget_type = SubBudgetType.new(sub_budget_type_params)
    authorize! params[:button].to_sym, @sub_budget_type if @sub_budget_type.respond_to?(:current_state)

    respond_to do |format|
      if @sub_budget_type.save && (!@sub_budget_type.respond_to?(:current_state) || @sub_budget_type.process_event!(params[:button]))
        format.html { redirect_to settings_sub_budget_types_url(q: params[:q], page: params[:page]), notice: 'Sub budget type was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_sub_budget_type_url(@sub_budget_type) }
      else
        format.html { render action: 'new' }
        format.json { render json: @sub_budget_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_budget_types/1
  # PATCH/PUT /sub_budget_types/1.json
  def update
    authorize! params[:button].to_sym, @sub_budget_type if @sub_budget_type.respond_to?(:current_state)

    respond_to do |format|
      if (params[:sub_budget_type].nil? || @sub_budget_type.update(sub_budget_type_params)) && (!@sub_budget_type.respond_to?(:current_state) || @sub_budget_type.process_event!(params[:button]))
        format.html { redirect_to settings_sub_budget_types_url(q: params[:q], page: params[:page]), notice: 'Sub budget type was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @sub_budget_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_budget_types/1
  # DELETE /sub_budget_types/1.json
  def destroy
    if params[:id]
      if (!@sub_budget_type.respond_to?(:current_state) || !@sub_budget_type.current_state.meta[:no_destroy]) &&
        (SubBudgetType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @sub_budget_type.send(r.name).count}.sum == 0)
        @sub_budget_type.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, SubBudgetType
      SubBudgetType.where(id: params[:ids]).each do |sub_budget_type|
        if can?(:destroy, sub_budget_type) &&
          (!sub_budget_type.respond_to?(:current_state) || !sub_budget_type.current_state.meta[:no_destroy]) &&
          (SubBudgetType.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| sub_budget_type.send(r.name).count}.sum == 0)
          sub_budget_type.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_sub_budget_types_url(q: params[:q], page: params[:page]), notice: 'Sub budget type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_budget_type
      @sub_budget_type = SubBudgetType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_budget_type_params
      params.require(:sub_budget_type).permit(:workflow_state, :workflow_state_updater_id, :budget_type_id, :no ,:name)
    end

    def default_layout
      "orb"
    end
end
