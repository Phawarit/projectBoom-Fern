json.array!(@wage_rates) do |wage_rate|
  json.extract! wage_rate, :id, :to_s, :workflow_state, :workflow_state_updater_id, :sub_budget_type_id, :no, :amount
  json.url settings_wage_rate_url(wage_rate, format: :json)
end