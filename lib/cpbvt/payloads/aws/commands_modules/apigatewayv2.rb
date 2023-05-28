module Cpbvt::Payloads::Aws::CommandsModules::Apigatewayv2
def self.included base; base.extend ClassMethods; end
module ClassMethods

# apigatewayv2 get-authorizers
def apigatewayv2_get_authorizers(region:, output_file:, api_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws apigatewayv2 get-authorizers \
--api-id #{api_id} \
--region #{region} --output json > #{output_file}
COMMAND
end

# apigatewayv2 get-integerations
def apigatewayv2_get_integrations(region:, output_file:, api_id:)
command = <<~COMMAND.strip.gsub("\n", " ")
aws apigatewayv2 get-integrations \
--api-id #{api_id} \
--region #{region} --output json > #{output_file}
COMMAND
end

# apigatewayv2 get-apis
def apigatewayv2_get_apis(region:, output_file:)
command = <<~COMMAND.strip.gsub("\n", " ")
aws apigatewayv2 get-apis \
--region #{region} --output json > #{output_file}
COMMAND
end

# ------
end; end