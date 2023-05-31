module Cpbvt::Payloads::Aws::CommandsModules::CognitoIdp
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool.html
def cognito_idp_describe_user_pool(user_pool_id:)
<<~COMMAND
aws cognito-idp describe-user-pool \
--user-pool-id #{user_pool_id}
COMMAND
end

# we manually set max results to 10, we shouldn't really see that many
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-user-pools.html
def cognito_idp_list_user_pools
<<~COMMAND
aws cognito-idp list-user-pools  \
--max-results 10
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-user-pool-clients.html
def cognito_idp_list_user_pool_clients(user_pool_id:)  
<<~COMMAND
aws cognito-idp list-user-pool-clients \
--user-pool-id #{user_pool_id}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-users.html
def cognito_idp_list_users(user_pool_id:)
<<~COMMAND
aws cognito-idp list-users \
--user-pool-id #{user_pool_id}
COMMAND
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool-client.html
def cognito_idp_describe_user_pool_client(user_pool_id:, client_id:)
<<~COMMAND
aws cognito-idp describe-user-pool-client \
--user-pool-id #{user_pool_id} \
--client-id #{client_id}
COMMAND
end
  
# ------
end; end