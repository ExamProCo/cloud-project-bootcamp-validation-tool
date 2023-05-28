module Cpbvt::Payloads::Aws::Commands::Lambda
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def lambda_get_function(region:, outputfile:, function_name:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws lambda get-function \
--function-name #{function_name} \
--region #{region} --output json > #{output_file}
COMMAND
end

# lambda list functions
def lambda_list_functions(region:, outputfile:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws lambda list-functions \
--region #{region} --output json > #{output_file}
COMMAND
end

# lambda list layers
def lambda_list_layers(region:, outputfile:)
  command = <<~COMMAND.strip.gsub("\n", " ")  
aws lambda list-layers \
--region #{region} --output json > #{output_file}
COMMAND
end
# ------
end; end