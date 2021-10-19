json.array!(@sub_budget_types) do |sub_budget_type|
  json.extract! sub_budget_type, :id, :to_s, :workflow_state, :workflow_state_updater_id, :kku_strategic_id, :no, :name
  json.url settings_sub_budget_type_url(sub_budget_type, format: :json)
end