module Cpbvt::Payloads::Aws::CommandsModules::Lambda
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/get-function.html
def lambda_get_function(function_name:)
<<~COMMAND
aws lambda get-function \
--function-name #{function_name}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-functions.html
def lambda_list_functions
<<~COMMAND
aws lambda list-functions
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-layers.html
def lambda_list_layers
<<~COMMAND
aws lambda list-layers
COMMAND
end

# ------
end; end