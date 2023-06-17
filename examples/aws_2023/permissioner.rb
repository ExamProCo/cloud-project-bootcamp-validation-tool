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
    self.add primary_region, :ecs_describe_clusters, general_params
    self.add primary_region, :ecs_list_services, general_params
    self.add primary_region, :ecs_describe_services, general_params, { services: [specific_params.backend_family]}
    self.add primary_region, :ecs_list_tasks, general_params, {cluster_name: specific_params.cluster_name, family: specific_params.backend_family}
    self.add primary_region, :acm_list_certificates, general_params
    self.add primary_region, :apigatewayv2_get_apis, general_params
    self.add primary_region, :cloudformation_list_stacks, general_params
    self.add primary_region, :codebuild_list_projects, general_params
    self.add primary_region, :codebuild_list_builds, general_params
    self.add primary_region, :codepipeline_list_pipelines, general_params
    self.add primary_region, :cognito_idp_list_user_pools, general_params
    self.add primary_region, :dynamodb_list_tables, general_params
    self.add primary_region, :dynamodbstreams_list_streams, general_params
    self.add primary_region, :ec2_describe_vpcs, general_params
    self.add primary_region, :ec2_describe_subnets, general_params
    self.add primary_region, :ec2_describe_route_tables, general_params
    self.add primary_region, :ec2_describe_internet_gateways, general_params
    self.add primary_region, :ec2_describe_security_groups, general_params
    self.add primary_region, :ec2_describe_route_tables, general_params
    self.add primary_region, :ecr_describe_repositories, general_params
    self.add primary_region, :ecs_list_task_definitions, general_params
    self.add primary_region, :elbv2_describe_load_balancers, general_params
    self.add primary_region, :elbv2_describe_target_groups, general_params
    self.add primary_region, :lambda_list_functions, general_params
    self.add primary_region, :lambda_list_layers, general_params
    self.add primary_region, :rds_describe_db_instances, general_params
    self.add primary_region, :rds_describe_db_subnet_groups, general_params
    self.add primary_region, :rds_describe_db_snapshots, general_params
    self.add primary_region, :route53_list_hosted_zones, general_params
    self.add primary_region, :servicediscovery_list_services, general_params
    self.add primary_region, :servicediscovery_list_namespaces, general_params
    self.add 'us-east-1', :acm_list_certificates, general_params
    self.add 'global', :cloudfront_list_distributions, general_params
    self.add 'global', :s3api_list_buckets, general_params

    self.add primary_region, :ecs_describe_tasks, general_params, {cluster_name: specific_params.cluster_name}


    aliases = [
      "#{specific_params.naked_domain_name}",
      "assets.#{specific_params.naked_domain_name}"
    ]
    self.add 'global', :cloudfront_get_distribution, general_params, {aliases: aliases}
    self.add 'global', :cloudfront_list_invalidations, general_params, {aliases: aliases}

    bucket_names = [
      specific_params.naked_domain_name,
      "www.#{specific_params.naked_domain_name}",
      "assets.#{specific_params.naked_domain_name}"
    ]
    self.add 'global', :s3api_get_bucket_notification_configuration, general_params,{bucket_names: bucket_names}
    self.add 'global', :s3api_get_bucket_policy, general_params, {bucket_names: bucket_names}
    self.add 'global', :s3api_get_bucket_cors, general_params, {bucket_names: bucket_names}
    self.add 'global', :s3api_get_bucket_website, general_params, {bucket_names: bucket_names}
    self.add 'global', :s3api_get_public_access_block, general_params, {bucket_names: bucket_names}

    self.add primary_region, :codebuild_batch_get_projects, general_params
    self.add primary_region, :acm_describe_certificate, general_params
    self.add primary_region, :apigatewayv2_get_authorizers, general_params
    self.add primary_region, :apigatewayv2_get_integrations, general_params
    self.add primary_region, :cloudformation_list_stack_resources, general_params
    self.add primary_region, :codepipeline_get_pipeline, general_params
    self.add primary_region, :cognito_idp_describe_user_pool, general_params
    self.add primary_region, :cognito_idp_list_user_pool_clients, general_params
    self.add primary_region, :cognito_idp_list_users, general_params
    self.add primary_region, :dynamodb_describe_table, general_params
    self.add primary_region, :dynamodbstreams_describe_stream, general_params
    self.add primary_region, :ecr_describe_images, general_params
    self.add primary_region, :elbv2_describe_listeners, general_params
    self.add primary_region, :elbv2_describe_load_balancer_attributes, general_params
    self.add primary_region, :elbv2_describe_target_group_attributes, general_params
    self.add primary_region, :lambda_get_function, general_params
    self.add primary_region, :route53_get_hosted_zone, general_params
    self.add primary_region, :route53_list_resource_record_sets, general_params

    Cpbvt::Payloads::Aws::Policy.generate!
  end

  def self.add region, command, general_params, specifc_params={}
    Cpbvt::Payloads::Aws::Policy.add region, command, general_params, specific_params
  end
end