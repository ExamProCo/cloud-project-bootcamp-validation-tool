module Cpbvt::Payloads::Aws::Policies::CognitoIdp
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool.html
def cognito_idp_describe_user_pool(user_pool_id:)
end

# we manually set max results to 10, we shouldn't really see that many
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-user-pools.html
def cognito_idp_list_user_pools
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-user-pool-clients.html
def cognito_idp_list_user_pool_clients(user_pool_id:)  
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-users.html
def cognito_idp_list_users(user_pool_id:)
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool-client.html
def cognito_idp_describe_user_pool_client(user_pool_id:, client_id:)
end
  
# ------
end; end