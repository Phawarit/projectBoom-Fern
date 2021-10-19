class SubBudgetType < ActiveRecord::Base
    scope :all_enabled, -> { order("budget_types.no, budget_types.name, sub_budget_types.no, sub_budget_types.name").includes(:sub_budget_type).where(["sub_budget_types.workflow_state IN (?)", self.enabled_states]) }

    belongs_to :workflow_state_updater, class_name: "User"
    belongs_to :budget_type

    has_many  :wage_rates
    
    validates :no, presence: true
    validates :name, presence: true, uniqueness: true
    validates :budget_type_id, presence: true
    
    def to_s
      name
    end
    
    def to_s_with_state
      "#{to_s} #{self.current_state.to_sym == :enabled ? "" : "[" + I18n.t("workflow.state.#{self.workflow_state}") + "]"}"
    end
    
    def to_s_long
      "#{SubBudgetType.human_attribute_name(:no)} #{no} #{name}"
    end
    
    def to_s_short
      "#{SubBudgetType.human_attribute_name(:no)} #{no}"
    end
    
    def to_s_sort
      "#{budget_type.to_s_sort} #{"%05d" % no} #{name}"
    end
    
    include Workflow
    workflow do
      state :new do
        event :submit, transitions_to: :enabled
      end
      state :enabled, meta: {no_destroy: true} do
        event :save_change, transitions_to: :enabled
        event :terminate, transitions_to: :terminated
      end
      state :terminated, meta: {no_destroy: true, disabled: true}
  
      on_transition do |from, to, event, *event_args|
        WorkflowStateLog.create({
          resource_class: self.class.to_s,
          resource_id: self.id,
          state_from: from,
          state_to: to,
          event: event,
          serialized_object: YAML.dump(self)
        })
      end
    end
  
    def self.active_states
      [:new, :enabled]
    end
  
    def self.enabled_states
      [:enabled]
    end
  
    def self.form_action_events(action_name = nil)
      {
        new: [:submit],
        create: [:submit], 
        edit: [:save_change],
        update: [:save_change], 
        show: [:terminate], 
        index: [:terminate]
      }[action_name.to_sym]
    end
    
    def terminate
      self.name = self.name + " #{Time.current.strftime("%Y%m%d%H%M")}"
      self.save
    end
end
