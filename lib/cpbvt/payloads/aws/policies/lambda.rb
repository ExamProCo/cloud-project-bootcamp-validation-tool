module Cpbvt::Payloads::Aws::Policies::Lambda
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# For S3 Event Notifications you have to add this policy
# if you want to see lambda information
def lambda_get_policy(aws_account_id:)
  {
    "Effect" => "Allow",
    "Action" => "lambda:GetPolicy",
    "Resource" => "*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/get-function.html
def lambda_get_function(aws_account_id:,region:,function_names:[])
  resources = function_names.map do |function_name| 
    "arn:aws:lambda:#{region}:#{aws_account_id}:function:#{function_namek}"
  end
  resources = "*" if resources.empty?
  {
    "Effect" => "Allow",
    "Action" => "lambda:GetFunction",
    "Resource" => resources
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