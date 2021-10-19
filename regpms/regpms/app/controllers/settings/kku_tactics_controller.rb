class Settings::KkuTacticsController < SettingsController
  load_and_authorize_resource :class => "KkuTactic"

  before_action :set_kku_tactic, only: [:show, :edit, :update, :destroy]

  # GET /kku_tactics
  # GET /kku_tactics.json
  def index
    if params[:q].blank?
      params[:q] = {}
      params[:q][:workflow_state_in] = KkuTactic.active_states.join(",")
    end if KkuTactic.respond_to?(:workflow_spec)
    [:workflow_state_in, :workflow_state_not_in].each do |to_split|
      params[:q][to_split] = params[:q][to_split].gsub(" ", ",").split(",") if params[:q] && params[:q][to_split].present? && (params[:q][to_split].class == String)
    end if KkuTactic.respond_to?(:workflow_spec)
    @q = KkuTactic.limit(params[:limit]).search(params[:q])
    @q.sorts = 'no' if @q.sorts.empty?
    @kku_tactics = request.format.html? ? @q.result.includes(:kku_strategic).paginate(:page => params[:page], :per_page => 20) : @q.result.includes(:kku_strategic)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /kku_tactics/1
  # GET /kku_tactics/1.json
  def show
  end

  # GET /kku_tactics/new
  def new
    @kku_tactic = KkuTactic.new
    render layout: !request.xhr?
  end

  # GET /kku_tactics/1/edit
  def edit
  end

  # POST /kku_tactics
  # POST /kku_tactics.json
  def create
    @kku_tactic = KkuTactic.new(kku_tactic_params)
    authorize! params[:button].to_sym, @kku_tactic if @kku_tactic.respond_to?(:current_state)

    respond_to do |format|
      if @kku_tactic.save && (!@kku_tactic.respond_to?(:current_state) || @kku_tactic.process_event!(params[:button]))
        format.html { redirect_to settings_kku_tactics_url(q: params[:q], page: params[:page]), notice: 'Kku tactic was successfully created.' }
        format.json { render action: 'show', status: :created, location: settings_kku_tactic_url(@kku_tactic) }
      else
        format.html { render action: 'new' }
        format.json { render json: @kku_tactic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kku_tactics/1
  # PATCH/PUT /kku_tactics/1.json
  def update
    authorize! params[:button].to_sym, @kku_tactic if @kku_tactic.respond_to?(:current_state)

    respond_to do |format|
      if (params[:kku_tactic].nil? || @kku_tactic.update(kku_tactic_params)) && (!@kku_tactic.respond_to?(:current_state) || @kku_tactic.process_event!(params[:button]))
        format.html { redirect_to settings_kku_tactics_url(q: params[:q], page: params[:page]), notice: 'Kku tactic was successfully updated.' }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.js { render action: 'edit' }
        format.json { render json: @kku_tactic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kku_tactics/1
  # DELETE /kku_tactics/1.json
  def destroy
    if params[:id]
      if (!@kku_tactic.respond_to?(:current_state) || !@kku_tactic.current_state.meta[:no_destroy]) &&
        (KkuTactic.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| @kku_tactic.send(r.name).count}.sum == 0)
        @kku_tactic.destroy
      end
    elsif params[:ids]
      authorize! :destroy_selected, KkuTactic
      KkuTactic.where(id: params[:ids]).each do |kku_tactic|
        if can?(:destroy, kku_tactic) &&
          (!kku_tactic.respond_to?(:current_state) || !kku_tactic.current_state.meta[:no_destroy]) &&
          (KkuTactic.reflect_on_all_associations(:has_many).select{|r| ![:delete_all, :destroy].include?(r.options[:dependent])}.map{|r| kku_tactic.send(r.name).count}.sum == 0)
          kku_tactic.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to settings_kku_tactics_url(q: params[:q], page: params[:page]), notice: 'Kku tactic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kku_tactic
      @kku_tactic = KkuTactic.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kku_tactic_params
      params.require(:kku_tactic).permit(:workflow_state, :workflow_state_updater_id, :kku_strategic_id, :no, :name)
    end

    def default_layout
      "orb"
    end
end
