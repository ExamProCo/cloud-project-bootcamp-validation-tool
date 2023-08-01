module Cpbvt::Payloads::Aws::Extractors::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# a limit of up to 100 tasks
def ecs_list_tasks__task_id data, filters={}
  if data['taskArns']
    data['taskArns'].map do |arn|
      task_id = arn.split('/').last
      {
        iter_id: task_id,
        task_id: task_id
      }
    end
  end
end

# ------
end; end