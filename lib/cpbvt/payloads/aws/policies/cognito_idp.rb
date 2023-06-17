module Cpbvt::Payloads::Aws::Policies::CognitoIdp
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool.html
def cognito_idp_describe_user_pool(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:DescribeUserPool",
    "Resource" => "arn:aws:cognito-idp:region:account-id:userpool/user-pool-id"
}
end

# we manually set max results to 10, we shouldn't really see that many
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-user-pools.html
def cognito_idp_list_user_pools(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:ListUserPools",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-user-pool-clients.html
def cognito_idp_list_user_pool_clients(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:ListUserPoolClients",
    "Resource" => "*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-users.html
def cognito_idp_list_users(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:ListUsers",
    "Resource" => "arn:aws:cognito-idp:region:account-id:userpool/user-pool-id"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool-client.html
def cognito_idp_describe_user_pool_client(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:DescribeUserPoolClient",
    "Resource" => "arn:aws:cognito-idp:region:account-id:userpool/user-pool-id/client/client-id"
  }
end
  
# ------
end; end