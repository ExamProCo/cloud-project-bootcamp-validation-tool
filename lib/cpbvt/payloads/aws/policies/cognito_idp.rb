module Cpbvt::Payloads::Aws::Policies::CognitoIdp
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cognito_idp_allow_general_permissions(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => [
      "cognito-idp:ListUserPools",
      "cognito-idp:ListUserPoolClients"
    ],
    "Resource" => "*"
  }
end


# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool.html
def cognito_idp_describe_user_pool(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:DescribeUserPool",
    "Resource" => "arn:aws:cognito-idp:#{region}:#{aws_account_id}:userpool/*"
}
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/list-users.html
def cognito_idp_list_users(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:ListUsers",
    "Resource" => "arn:aws:cognito-idp:#{region}:#{aws_account_id}:userpool/*"
  }
end

# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/describe-user-pool-client.html
def cognito_idp_describe_user_pool_client(aws_account_id:,region:)
  {
    "Effect" => "Allow",
    "Action" => "cognito-idp:DescribeUserPoolClient",
    "Resource" => "arn:aws:cognito-idp:#{region}:#{aws_account_id}:userpool/*/client/*"
  }
end
  
# ------
end; end