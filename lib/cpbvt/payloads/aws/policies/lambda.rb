module Cpbvt::Payloads::Aws::Policies::Lambda
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/get-function.html
def lambda_get_function(aws_account_id:,region:,function_name:)
  {
    "Effect": "Allow",
    "Action": "lambda:GetFunction",
    "Resource": "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-functions.html
def lambda_list_functions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "lambda:ListFunctions",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-layers.html
def lambda_list_layers(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "lambda:ListLayers",
    "Resource" => "*"
  }
end

# ------
end; end