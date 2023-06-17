module Cpbvt::Payloads::Aws::Policies::Apigatewayv2
def self.included base; base.extend ClassMethods; end
module ClassMethods

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-authorizers.html
def apigatewayv2_get_authorizers(api_id:)
  {
    "Effect" => "Allow",
    "Action" => "apigateway:GET",
    "Resource" => "arn:aws:apigateway:#{region}::/apis/#{api_id}/authorizers/*"
  }
end

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-integrations.html
def apigatewayv2_get_integrations(api_id:)
  {
    "Effect" => "Allow",
    "Action" => "apigateway:GET",
    "Resource" => "arn:aws:apigateway:#{region}::/apis/#{api_id}/integrations/*"
  }
end

# https://docs.aws.amazon.com/cli/latest/reference/apigatewayv2/get-apis.html
def apigatewayv2_get_apis
  {
    "Effect": "Allow",
    "Action": "apigateway:GET",
    "Resource": "*"
  }
end

# ------
end; end