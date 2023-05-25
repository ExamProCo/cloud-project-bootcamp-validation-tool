require_relative 'cpbvt/module_defs'
require_relative 'cpbvt/version'
require_relative 'cpbvt/uploader'
require_relative 'cpbvt/payloads/aws'
require_relative 'cpbvt/validations/aws_2023'

class Cpbvt::Aws2023
  def self.run project_scope:,
               user_uuid:,
               region:,
               user_region:,
               output_path:,
               aws_access_key_id:,
               aws_secret_access_key:,
               payloads_bucket:
    attrs = {
      project_scope: project_scope,
      user_uuid: user_uuid,
      region: region,
      user_region: user_region,
      output_path: output_path,
      aws_access_key_id: aws_access_key_id,
      aws_secret_access_key: aws_secret_access_key,
      payloads_bucket: payloads_bucket
    }
    Cpbvt::Payloads::Aws::Runner.run :ec2_describe_vpcs, attrs.merge({filename: 'describe-vpcs.json'})
    Cpbvt::Payloads::Aws::Runner.run :s3api_list_buckets, attrs.merge({user_region: 'global',filename: 's3api_list_buckets.json'})
  end # def self.run
end # class AwsBootcamp2023