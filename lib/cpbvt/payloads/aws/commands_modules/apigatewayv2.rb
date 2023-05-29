module Cpbvt::Payloads::Aws::CommandsModules::Apigatewayv2
def self.included base; base.extend ClassMethods; end
module ClassMethods

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-authorizers.html
def apigatewayv2_get_authorizers(api_id:)
<<~COMMAND
aws apigatewayv2 get-authorizers \
--api-id #{api_id}
COMMAND
end

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-integrations.html
def apigatewayv2_get_integrations(api_id:)
<<~COMMAND
aws apigatewayv2 get-integrations \
--api-id #{api_id}
COMMAND
end

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-apis.html
def apigatewayv2_get_apis
<<~COMMAND
aws apigatewayv2 get-apis
COMMAND
end

# ------
end; end