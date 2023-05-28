module Cpbvt::Payloads::Aws::Commands::CognitoIdp
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------
  
def cognito_describe_user_pool(region: output_file:, :user_pool_id)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cognito-idp describe-user-pool \
--user-pool-id #{user_pool_id} \
--region #{region} --output json > #{output_file}
COMMAND
end

def cognito_list_user_pools(region:, output_file:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cognito-idp list-user-pools  \
--region #{region} --output json > #{output_file}
COMMAND
end

def cognito_list_user_pool_clients(region:, output_file:, user_pool_id:)  
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cognito-idp list-user-pool-clients \
--user-pool-id #{user_pool_id} \
--region #{region} --output json > #{output_file}
COMMAND
end

def cognito_list_users(region:, output_file:, user_pool_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cognito-idp list-users \
--user-pool-id #{user_pool_id} \
--region #{region} --output json > #{output_file}
COMMAND
end

def cognito_describe_user_pool_client(region:, output_file:, user_pool_id:, client_id:)
  command = <<~COMMAND.strip.gsub("\n", " ")
aws cognito-idp describe-user-pool-client \
--user-pool-id #{user_pool_id} \
--client-id #{client_id} \
--region #{region} --output json > #{output_file}
COMMAND
end
  
# ------
end; end