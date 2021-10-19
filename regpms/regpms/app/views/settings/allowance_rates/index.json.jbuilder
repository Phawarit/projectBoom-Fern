json.array!(@allowance_rates) do |allowance_rate|
  json.extract! allowance_rate, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sub_budget_type_id, :name
  json.url settings_allowance_rate_url(allowance_rate, format: :json)
end