require_relative 'cpbvt/module_defs'
require_relative 'cpbvt/version'
require_relative 'cpbvt/uploader'
require_relative 'cpbvt/manifest'
require_relative 'cpbvt/payloads/aws/runner'
require_relative 'cpbvt/payloads/aws/commands'
require_relative 'cpbvt/payloads/aws/policies'
require_relative 'cpbvt/validations/aws_2023'

class Cpbvt::Aws2023
  def self.run project_scope:,
               user_uuid:,
               run_uuid:,
               region:,
               user_region:,
               output_path:,
               aws_access_key_id:,
               aws_secret_access_key:,
               payloads_bucket:
    manifest = Cpbvt::Manifest.new(
      user_uuid: user_uuid, 
      run_uuid: run_uuid, 
      project_scope: project_scope,
      output_path: output_path,
      payloads_bucket: payloads_bucket
    )
    attrs = {
      project_scope: project_scope,
      run_uuid: run_uuid,
      user_uuid: user_uuid,
      region: region,
      user_region: user_region,
      output_path: output_path,
      aws_access_key_id: aws_access_key_id,
      aws_secret_access_key: aws_secret_access_key,
      payloads_bucket: payloads_bucket
    }

    # Region Specific Commands
    %w{
      ec2_describe_vpcs
      ec2_describe_subnets
      ec2_describe_route_tables
      ec2_describe_internet_gateways
      ec2_describe_security_groups
      elbv2_describe_load_balancers
      elbv2_describe_target_groups
      rds_describe_db_instances
      dynamodb_list_tables
      ecr_describe_repositories
    }.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, attrs.merge({
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end

    # Global Commands
    %w{
      s3api_list_buckets
    }.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, attrs.merge({
        user_region: 'global',
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end

    manifest.write_file
    Cpbvt::Uploader.run(
      file_path: manifest.output_file, 
      object_key: manifest.object_key,
      aws_region: region,
      aws_access_key_id: aws_access_key_id,
      aws_secret_access_key: aws_secret_access_key,
      payloads_bucket: payloads_bucket
    )
  end # def self.run
end # class AwsBootcamp2023