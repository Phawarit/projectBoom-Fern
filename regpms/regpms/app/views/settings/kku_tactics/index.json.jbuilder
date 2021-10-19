json.array!(@kku_tactics) do |kku_tactic|
  json.extract! kku_tactic, :id, :to_s, :workflow_state, :workflow_state_updater_id, :kku_strategic_id, :no, :name
  json.url settings_kku_tactic_url(kku_tactic, format: :json)
end