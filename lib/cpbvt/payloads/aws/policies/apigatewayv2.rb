module Cpbvt::Payloads::Aws::Policies::Apigatewayv2
def self.included base; base.extend ClassMethods; end
module ClassMethods

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-authorizers.html
def apigatewayv2_get_authorizers(api_id:)
end

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-integrations.html
def apigatewayv2_get_integrations(api_id:)
end

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-apis.html
def apigatewayv2_get_apis
end

# ------
end; end