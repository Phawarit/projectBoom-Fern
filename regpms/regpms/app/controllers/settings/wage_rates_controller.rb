class Settings::WageRatesController < SettingsController
  load_and_authorize_resource :class => "WageRate"

  before_action :set_wage_rate, only: [:show, :edit, :update, :destroy]

  # GET /wage_rates
  # GET /wage_rates.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = WageRate.active_states.join(",")
    end if WageRate.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if WageRate.respond_to?(:workflow_spec)
    @q = WageRate.limit(params[:limit]).search(params[:q])
    @q.sorts = 'no' if @q.sorts.empty?
    @wage_rates = request.format.html? ? @q.result.includes(:sub_budget_type).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:sub_budget_type)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /wage_rates/1
  # GET /wage_rates/1.json
  def show
  end

  # GET /wage_rates/new
  def new
    @wage_rate = WageRate.new
    render layout: !request.xhr?

  end

  # GET /wage_rates/1/edit
  def edit
  end

  # POST /wage_rates
  # POST /wage_rates.json
  def create
    @wage_rate = WageRate.new(wage_rate_params)
    authorize! params[:button].to_sym, @wage_rate if @wage_rate.respond_to?(:current_state)

    respond_to do |format|
      if @wage_rate.save && (!@wage_rate.respond_to?(:current_state) || @wage_rate.process_event!(params[:button]))
        format.html { redirect_to settings_wage_rates_url(q: params[:q], page: params[:page]), notice: 'Kku tactic was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_wage_rate_url(@wage_rate) }
      else
        format.html { render action: 'new' }
        format.json { render json: @wage_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wage_rates/1
  # PATCH/PUT /wage_rates/1.json
  def update
    authorize! params[:button].to_sym, @wage_rate if @wage_rate.respond_to?(:current_state)

    respond_to do |format|
      if (params[:wage_rate].nil? || @wage_rate.update(wage_rate_params)) && (!@wage_rate.respond_to?(:current_state) || @wage_rate.process_event!(params[:button]))
        format.html { redirect_to settings_wage_rates_url(q: params[:q], page: params[:page]), notice: 'Kku tactic was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @wage_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wage_rates/1
  # DELETE /wage_rates/1.json
  def destroy
    if params[:id]
      if (!@wage_rate.respond_to?(:current_state) || !@wage_rate.current_state.meta[:no_destroy]) &&
        (WageRate.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @wage_rate.send(r.name).count}.sum == 0)
        @wage_rate.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, WageRate
      WageRate.where(id: params[:ids]).each do |wage_rate|
        if can?(:destroy, wage_rate) &&
          (!wage_rate.respond_to?(:current_state) || !wage_rate.current_state.meta[:no_destroy]) &&
          (WageRate.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| wage_rate.send(r.name).count}.sum == 0)
          wage_rate.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_wage_rates_url(q: params[:q], page: params[:page]), notice: 'Kku tactic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wage_rate
      @wage_rate = WageRate.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wage_rate_params
      params.require(:wage_rate).permit(:workflow_state, :workflow_state_updater_id, :sub_budget_type_id, :no, :amount)
    end
end
