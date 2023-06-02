module Cpbvt::Payloads::Aws::Policies::Lambda
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/get-function.html
def lambda_get_function(function_name:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-functions.html
def lambda_list_functions
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-layers.html
def lambda_list_layers
end

# ------
end; end