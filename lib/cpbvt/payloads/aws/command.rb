require 'open3'

class Cpbvt::Payloads::Aws::Command
  include Cpbvt::Payloads::Aws::Commands::Acm
  include Cpbvt::Payloads::Aws::Commands::Apigatewayv2
  include Cpbvt::Payloads::Aws::Commands::Cloudformation
  include Cpbvt::Payloads::Aws::Commands::Cloudfront
  include Cpbvt::Payloads::Aws::Commands::Codebuild
  include Cpbvt::Payloads::Aws::Commands::Codepipeline
  include Cpbvt::Payloads::Aws::Commands::CognitoIdp
  include Cpbvt::Payloads::Aws::Commands::Dynamodb
  include Cpbvt::Payloads::Aws::Commands::Dynamodbstreams
  include Cpbvt::Payloads::Aws::Commands::Ec2
  include Cpbvt::Payloads::Aws::Commands::Ecr
  include Cpbvt::Payloads::Aws::Commands::Ecs
  include Cpbvt::Payloads::Aws::Commands::Elbv2
  include Cpbvt::Payloads::Aws::Commands::Lambda
  include Cpbvt::Payloads::Aws::Commands::Rds
  include Cpbvt::Payloads::Aws::Commands::Route53
  include Cpbvt::Payloads::Aws::Commands::S3api
  include Cpbvt::Payloads::Aws::Commands::Servicediscovery

  def self.session_token target_aws_account_id
command = <<~COMMAND
aws sts assume-role \
--role-arn "arn:aws:iam::#{target_aws_account_id}:role/CrossAccountRole" \
--role-session-name "crossAccountAccess" \
--external-id #{ENV['EXTERNAL_ID']}
COMMAND
puts "[Executing] #{command}"
stdout_str, exit_code = Open3.capture2(command)#, :stdin_data=>post_content)
payload = JSON.parse(stdout_str)
result = payload['Credentials']
return result
  end
end