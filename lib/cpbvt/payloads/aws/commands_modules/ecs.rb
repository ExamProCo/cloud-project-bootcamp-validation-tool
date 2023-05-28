module Cpbvt::Payloads::Aws::CommandsModules::Ecs
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
def ecs_describe_clusters(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ecs describe-clusters \
--region #{region} --output json > #{output_file}
COMMAND
end

# services is required - a list of services to describe
def ecs_describe_services(region:, output_file:, services:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ecs describe-services \
--services #{services} \
--region #{region} --output json > #{output_file}
COMMAND
end

def ecs_describe_tasks(region:, output_file:, cluster:, tasks:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ecs describe-tasks \
--tasks #{tasks} \
--cluster #{cluster} \
--region #{region} --output json > #{output_file}
COMMAND
end

def ecs_list_tasks(region:, output_file:, cluster:, family:)
    command = <<~COMMAND.strip.gsub("\n", " ")
aws ecs list-tasks \
--cluster #{cluster} \
--family #{family} \
--region #{region} --output json > #{output_file}
COMMAND
end

def ecs_list_task_definitions(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws ecs list-task-definitions \
--region #{region} --output json > #{output_file}
COMMAND
end
# ------
end; end