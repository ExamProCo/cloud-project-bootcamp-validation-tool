require 'fileutils'
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

  def self.add region, command, general_params, specific_params
    specific_params[:aws_account_id] = general_params.target_aws_account_id
    specific_params[:region] = region if region != 'global'

    permissions = self.send command, **specific_params
    permissions = [permissions] if permissions.is_a?(Hash)
    if region != 'global'
      permissions.map! do |permission|
        self.condition_region permission, region
      end
    end
    permissions.each do |permission|
      @@permissions.push permission
    end
  end

  def self.condition_region permission, region
    permission['Condition'] ||= {}
    permission['Condition']['StringEquals'] ||= {}
    permission['Condition']['StringEquals']["aws:RequestedRegion"] = region
    permission
  end

  def self.generate! general_params
    path = File.join(
      File.dirname(File.expand_path(__FILE__)),
      'cross-account-role-template.yaml'
    )
    cfn_template = YAML.load_file(path)
    cfn_template['Resources']['CrossAccountRole']['Properties']['Policies'][0]['PolicyDocument']['Statement'] = @@permissions

    output_path = File.join(
      general_params.output_path,
      general_params.project_scope,
      "user-#{general_params.user_uuid}",
      "cross-account-role.yaml"
    )

    dirpath = File.dirname output_path
    FileUtils.mkdir_p(dirpath)

    File.open(output_path, 'w') do |f|
      f.write(cfn_template.to_yaml)
    end
  end
end