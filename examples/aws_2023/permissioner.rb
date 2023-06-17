class Aws2023::Permissioner
  def self.run(general_params:,specific_params:)
    unless general_params.valid?
      puts general_params.errors.full_messages
      raise "failed to pass general params validation"
    end

    unless specific_params.valid?
      puts specific_params.errors.full_messages
      raise "failed to specific params validation"
    end

    primary_region = general_params.user_region
    self.add primary_region, :ecs_describe_clusters
    self.add primary_region, :ecs_list_services
    self.add primary_region, :ecs_describe_services, { services: [specific_params.backend_family]}
    self.add primary_region, :ecs_list_tasks, {cluster_name: specific_params.cluster_name, family: specific_params.backend_family}
    self.add primary_region, :acm_list_certificates
    self.add primary_region, :apigatewayv2_get_apis
    self.add primary_region, :cloudformation_list_stacks
    self.add primary_region, :codebuild_list_projects
    self.add primary_region, :codebuild_list_builds
    self.add primary_region, :codepipeline_list_pipelines
    self.add primary_region, :cognito_idp_list_user_pools
    self.add primary_region, :dynamodb_list_tables
    self.add primary_region, :dynamodbstreams_list_streams
    self.add primary_region, :ec2_describe_vpcs
    self.add primary_region, :ec2_describe_subnets
    self.add primary_region, :ec2_describe_route_tables
    self.add primary_region, :ec2_describe_internet_gateways
    self.add primary_region, :ec2_describe_security_groups
    self.add primary_region, :ec2_describe_route_tables
    self.add primary_region, :ecr_describe_repositories
    self.add primary_region, :ecs_list_task_definitions
    self.add primary_region, :elbv2_describe_load_balancers
    self.add primary_region, :elbv2_describe_target_groups
    self.add primary_region, :lambda_list_functions
    self.add primary_region, :lambda_list_layers
    self.add primary_region, :rds_describe_db_instances
    self.add primary_region, :rds_describe_db_subnet_groups
    self.add primary_region, :rds_describe_db_snapshots
    self.add primary_region, :route53_list_hosted_zones
    self.add primary_region, :servicediscovery_list_services
    self.add primary_region, :servicediscovery_list_namespaces
    self.add 'us-east-1', :acm_list_certificates
    self.add 'global', :cloudfront_list_distributions
    self.add 'global', :s3api_list_buckets

    self.add primary_region, :ecs_describe_tasks, {cluster_name: specific_params.cluster_name}


    aliases = [
      "#{specific_params.naked_domain_name}",
      "assets.#{specific_params.naked_domain_name}"
    ]
    self.add 'global', :cloudfront_get_distribution, {aliases: aliases}
    self.add 'global', :cloudfront_list_invalidations, {aliases: aliases}

    bucket_names = [
      specific_params.naked_domain_name,
      "www.#{specific_params.naked_domain_name}",
      "assets.#{specific_params.naked_domain_name}"
    ]
    self.add 'global', :s3api_get_bucket_notification_configuration, {bucket_names: bucket_names}
    self.add 'global', :s3api_get_bucket_policy, {bucket_names: bucket_names}
    self.add 'global', :s3api_get_bucket_cors, {bucket_names: bucket_names}
    self.add 'global', :s3api_get_bucket_website, {bucket_names: bucket_names}
    self.add 'global', :s3api_get_public_access_block, {bucket_names: bucket_names}

    self.add primary_region, :codebuild_batch_get_projects
    self.add primary_region, :acm_describe_certificate
    self.add primary_region, :apigatewayv2_get_authorizers
    self.add primary_region, :apigatewayv2_get_integrations
    self.add primary_region, :cloudformation_list_stack_resources
    self.add primary_region, :codepipeline_get_pipeline
    self.add primary_region, :cognito_idp_describe_user_pool
    self.add primary_region, :cognito_idp_list_user_pool_clients
    self.add primary_region, :cognito_idp_list_users
    self.add primary_region, :dynamodb_describe_table
    self.add primary_region, :dynamodbstreams_describe_stream
    self.add primary_region, :ecr_describe_images
    self.add primary_region, :elbv2_describe_listeners
    self.add primary_region, :elbv2_describe_load_balancer_attributes
    self.add primary_region, :elbv2_describe_target_group_attributes
    self.add primary_region, :lambda_get_function
    self.add primary_region, :route53_get_hosted_zone
    self.add primary_region, :route53_list_resource_record_sets

    Cpbvt::Payloads::Aws::Policy.generate!
  end

  def self.add region, command, params={}
    Cpbvt::Payloads::Aws::Policy.add region, command, params
  end
end