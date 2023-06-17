require 'yaml'
class Cpbvt::Payloads::Aws::Policy
  include Cpbvt::Payloads::Aws::Policies::Acm
  include Cpbvt::Payloads::Aws::Policies::Apigatewayv2
  include Cpbvt::Payloads::Aws::Policies::Cloudformation
  include Cpbvt::Payloads::Aws::Policies::Cloudfront
  include Cpbvt::Payloads::Aws::Policies::Codebuild
  include Cpbvt::Payloads::Aws::Policies::Codepipeline
  include Cpbvt::Payloads::Aws::Policies::CognitoIdp
  include Cpbvt::Payloads::Aws::Policies::Dynamodb
  include Cpbvt::Payloads::Aws::Policies::Dynamodbstreams
  include Cpbvt::Payloads::Aws::Policies::Ec2
  include Cpbvt::Payloads::Aws::Policies::Ecr
  include Cpbvt::Payloads::Aws::Policies::Ecs
  include Cpbvt::Payloads::Aws::Policies::Elbv2
  include Cpbvt::Payloads::Aws::Policies::Lambda
  include Cpbvt::Payloads::Aws::Policies::Rds
  include Cpbvt::Payloads::Aws::Policies::Route53
  include Cpbvt::Payloads::Aws::Policies::S3api
  include Cpbvt::Payloads::Aws::Policies::Servicediscovery

  @@permissions = []

  def self.add region, command, params
    permissions = self.send command
    if permissions.is_a?(Array)
      permissions.each do |permission|
        @@permissions.push permission
      end
    else
      @@permissions.push permissions
    end
  end

  def generate!
    cfn_template = YAML.load_file('cross-account-role-template.yaml')
    binding.pry
  end
end