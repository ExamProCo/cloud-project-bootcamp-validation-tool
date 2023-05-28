require_relative 'cpbvt/module_defs'
require_relative 'cpbvt/version'
require_relative 'cpbvt/uploader'
require_relative 'cpbvt/manifest'
# --- require cpbvt/payloads/aws/commands/*
aws_commands_path = File.join(File.dirname(__FILE__),'cpbvt','payloads','aws','commands_modules','*.rb')
Dir.glob(aws_commands_path,&method(:require))
# ---
require_relative 'cpbvt/payloads/aws/runner'
require_relative 'cpbvt/payloads/aws/commands.rb'
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

    # Primary Region-Specific Commands
    %w{
      acm_list_certificates
      apigatewayv2_get_apis
      codebuild_list_projects
      codebuild_list_builds
      codepipeline_list_pipelines
      cognito_list_user_pools
      dynamodb_list_tables
      dynamodbstreams_list_streams
      ec2_describe_vpcs
      ec2_describe_subnets
      ec2_describe_route_tables
      ec2_describe_internet_gateways
      ec2_describe_security_groups
      ec2_describe_route_tables
      ecr_describe_repositories
      ecs_describe_clusters
      ecs_list_task_definitions
      elbv2_describe_load_balancers
      elbv2_describe_target_groups
      lambda_list_functions
      lambda_list_layers
      rds_describe_db_instances
      rds_describe_db_subnet_groups
      rds_describe_db_snapshots
      route53_list_hosted_zones
      servicediscovery_list_services
      servicediscovery_list_namespaces
    }.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, attrs.merge({
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end

    # Alternate Region-Specific Commands
    # - acm_list_certificates for CloudFront since it has to use one in us-east-1
    %w{
      acm_list_certificates
    }.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, attrs.merge({
        user_region: 'us-east-1',
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end

    # Global Commands
    %w{
      cloudfront_list_distributions
      cloudfront_list_cloud_front_origin_access_identities
      s3api_list_buckets
    }.each do |command|
      result = Cpbvt::Payloads::Aws::Runner.run command, attrs.merge({
        user_region: 'global',
        filename: "#{command.gsub('_','-')}.json"
      })
      manifest.add_payload command, result
    end

    # Specific AWS Resources
    # - acm_describe_certificate
    # - apigatewayv2_get_authorizers
    # - apigatewayv2_get_integrations
    # - cloudfront_get_distribution
    # - cloudfront_list_invalidations
    # - cloudfront_get_cloud_front_origin_access_identity
    # - codepipeline_get_pipeline
    # - cognito_describe_user_pool
    # - cognito_list_user_pool_clients
    # - cognito_list_users
    # - cognito_describe_user_pool_client
    # - dynamodb_describe_table
    # - dynamodbstreams_describe_stream
    # - ecs_describe_services
    # - ecs_describe_tasks
    # - ecs_list_tasks
    # - ecr_describe_images
    # - elbv2_describe_target_group_attributes
    # - elbv2_describe_load_balancer_attributes
    # - elbv2_describe_listeners
    # - lambda_get_function
    # - route53_get_hosted_zone
    # - route53_list_resource_record_sets
    # - s3api_head_bucket
    # - s3api_get_bucket_notification_configuration
    # - s3api_get_bucket_policy
    # - s3api_get_bucket_cors
    # - s3api_get_bucket_website
    # - s3api_get_object_header
    # - s3api_get_object
    # - s3api_get_public_access_block
    # - s3api_list_objects_v2
    # - elbv2_describe_rules

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