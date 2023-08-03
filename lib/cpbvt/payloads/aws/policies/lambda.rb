module Cpbvt::Payloads::Aws::Policies::Lambda
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def lambda_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "lambda:GetPolicy",
      "lambda:ListFunctions",
      "lambda:ListLayers"
    ],
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

# ------
end; end