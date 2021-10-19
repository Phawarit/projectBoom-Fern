class Settings::AllowanceRatesController < SettingsController
  load_and_authorize_resource :class => "AllowanceRate"
  before_action :set_allowance_rate, only: [:show, :edit, :update, :destroy]

  # GET /settings/allowance_rates
  # GET /settings/allowance_rates.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = AllowanceRate.active_states.join(",")
    end if AllowanceRate.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if AllowanceRate.respond_to?(:workflow_spec)
    @q = AllowanceRate.limit(params[:limit]).search(params[:q])
    @allowance_rates = request.format.html? ? @q.result.includes(:sub_budget_type).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:sub_budget_type)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /allowance_rates/1
  # GET /allowance_rates/1.json
  def show
  end

  # GET /allowance_rates/new
  def new
    @allowance_rate = AllowanceRate.new
    render layout: !request.xhr?

  end

  # GET /allowance_rates/1/edit
  def edit
  end

  # POST /allowance_rates
  # POST /allowance_rates.json
  def create
    @allowance_rate = AllowanceRate.new(allowance_rate_params)
    authorize! params[:button].to_sym, @allowance_rate if @allowance_rate.respond_to?(:current_state)

    respond_to do |format|
      if @allowance_rate.save && (!@allowance_rate.respond_to?(:current_state) || @allowance_rate.process_event!(params[:button]))
        format.html { redirect_to settings_allowance_rates_url(q: params[:q], page: params[:page]), notice: 'Allowance rate was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_allowance_rate_url(@allowance_rate) }
      else
        format.html { render action: 'new' }
        format.json { render json: @allowance_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /allowance_rates/1
  # PATCH/PUT /allowance_rates/1.json
  def update
    authorize! params[:button].to_sym, @allowance_rate if @allowance_rate.respond_to?(:current_state)

    respond_to do |format|
      if (params[:allowance_rate].nil? || @allowance_rate.update(allowance_rate_params)) && (!@allowance_rate.respond_to?(:current_state) || @allowance_rate.process_event!(params[:button]))
        format.html { redirect_to settings_allowance_rates_url(q: params[:q], page: params[:page]), notice: 'Allowance rate was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @allowance_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /allowance_rates/1
  # DELETE /allowance_rates/1.json
  def destroy
    if params[:id]
      if (!@allowance_rate.respond_to?(:current_state) || !@allowance_rate.current_state.meta[:no_destroy]) &&
        (AllowanceRate.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @allowance_rate.send(r.name).count}.sum == 0)
        @allowance_rate.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, AllowanceRate
      AllowanceRate.where(id: params[:ids]).each do |allowance_rate|
        if can?(:destroy, allowance_rate) &&
          (!allowance_rate.respond_to?(:current_state) || !allowance_rate.current_state.meta[:no_destroy]) &&
          (AllowanceRate.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| allowance_rate.send(r.name).count}.sum == 0)
          allowance_rate.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_allowance_rates_url(q: params[:q], page: params[:page]), notice: 'Allowance rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_allowance_rate
      @allowance_rate = AllowanceRate.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def allowance_rate_params
      params.require(:allowance_rate).permit(:workflow_state, :workflow_state_updater_id, :sub_budget_type_id, :amount)
    end

    def default_layout
      "orb"
    end
end
