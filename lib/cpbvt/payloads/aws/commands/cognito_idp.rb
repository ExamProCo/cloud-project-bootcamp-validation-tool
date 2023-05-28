module Cpbvt::Payloads::Aws::Commands::CognitoIdp
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
def cognito_describe_user_pool(user_pool_id:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cognito-idp describe-user-pool --user-pool-id #{user_pool_id} --output json > #{output_file}
COMMAND
end
  
# ------
end; end