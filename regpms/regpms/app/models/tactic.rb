# encoding: utf-8

class Tactic < ActiveRecord::Base
  
  scope :all_enabled, -> { order(:name).where(workflow_state: :enabled) }
  
  belongs_to :workflow_state_updater, class_name: "User"
  belongs_to :strategy
  has_one :strategy_group, through: :strategy
  
  has_many :measures, -> { order("no").where(workflow_state: :enabled) }
  accepts_nested_attributes_for :measures, :reject_if => :all_blank, :allow_destroy => true
  
  validates :sorting, presence: true, uniqueness: {scope: [:strategy_id]}
  validates :name, presence: true
  
  def to_s
    "กลยุทธ์ที่  #{code} #{name}"
  end
  
  def code
    strategy ? "#{strategy.code}.#{sorting}" : "#{sorting}"
  end
  
  def strategy_code
    strategy ? "#{strategy.code}" : ""
  end
  
  def strategy_year
    strategy ? strategy.year : nil
  end
  
  def strategy_group_code
    strategy_group ? "#{strategy_group.code}" : ""
  end
  
  def strategy_group_id
    strategy_group ? strategy_group.id : nil
  end
  
  def year
    strategy ? strategy.year : nil
  end
  
  include Workflow
  workflow do
    state :new do
      event :submit, transitions_to: :enabled
    end
    state :enabled, meta: {no_destroy: true} do
      event :save_change, transitions_to: :enabled
      event :disable, transitions_to: :disabled
      event :terminate, transitions_to: :terminated
    end
    state :disabled, meta: {no_destroy: true} do
      event :save_change, transitions_to: :disabled
      event :enable, transitions_to: :enabled
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
    [:enabled, :disabled]
  end

  def self.form_action_events(action_name = nil)
    {
      new: [:submit],
      create: [:submit], 
      edit: [:save_change],
      update: [:save_change,], 
      show: [:enable, :disable, :terminate], 
      index: [:enable, :disable, :terminate]
    }[action_name.to_sym]
  end
  
end
