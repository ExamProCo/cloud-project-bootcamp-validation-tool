module Cpbvt::Payloads::Aws::Commands::Ec2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def codepipeline_list_pipelines(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws codepipeline list-pipelines \
--region #{region} --output json > #{output_file}
COMMAND
end

def codepipeline_get_pipeline(region::, output_file:, pipeline_name:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws codepipeline get-pipeline \
--name #{pipeline_name} \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end