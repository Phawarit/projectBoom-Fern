json.array!(@evaluation_salary_up_users) do |evaluation_salary_up_user|
  json.extract! evaluation_salary_up_user, :id, :to_s, :workflow_state, :workflow_state_updater_id, :evaluation_id, :evaluation_salary_up_id, :user_id, :position_level_id, :salary, :base_salary, :base_salary_min, :base_salary_max, :is_eligible, :is_work_hour_passed, :lost_count, :late_count, :leave_count, :point, :percent_of_min_up, :salary_min_up, :percent_of_up, :salary_up
  json.url evaluation_salary_up_user_url(evaluation_salary_up_user, format: :json)
end