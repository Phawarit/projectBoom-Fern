class Expense < ActiveRecord::Base

  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :project
  belongs_to :budget_group
  belongs_to :budget_type
  belongs_to :allowance_rate
  belongs_to :sub_budget_type
  belongs_to :wage_rate
  validates :project_id, presence: true
  # validates :sorting, presence: true, uniqueness: {scope: [:project_id]}
  validates :budget_group_id, presence: true
  validates :budget_type_id, presence: true

  validates :date, presence: true
  validates :description, presence: true
  validates :amount, presence: true
  validates :by, presence: true

  validates_presence_of  :amount
  # :hr,, :budget_type, :sub_budget_type, :wage_rate


  def to_s
    "#{project ? project.code : nil} - #{budget_group} - #{budget_type} - #{allowance_rate} - #{date.to_s_lazy} - #{description} - #{amount.to_s_decimal_comma} - #{by}"
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

end