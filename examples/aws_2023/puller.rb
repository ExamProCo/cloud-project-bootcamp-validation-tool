class Aws2023::Puller
  def self.run(general_params:,specific_params:)
    unless general_params.valid?
      puts general_params.errors.full_messages
      raise "failed to pass general params validation"
    end

    unless specific_params.valid?
      puts specific_params.errors.full_messages
      raise "failed to specific params validation"
    end

    manifest = Cpbvt::Manifest.new(
      user_uuid: general_params.user_uuid, 
      run_uuid: general_params.run_uuid, 
      project_scope: general_params.project_scope,
      output_path: general_params.output_path,
      payloads_bucket: general_params.payloads_bucket
    )

    primary_region = general_params.user_region
    self.pull primary_region, :acm_list_certificates, manifest, general_params
    self.pull primary_region, :apigatewayv2_get_apis, manifest, general_params
    self.pull primary_region, :cloudformation_list_stacks, manifest, general_params
    self.pull primary_region, :codebuild_list_projects, manifest, general_params
    self.pull primary_region, :codebuild_list_builds, manifest, general_params
    self.pull primary_region, :codepipeline_list_pipelines, manifest, general_params
    self.pull primary_region, :cognito_idp_list_user_pools, manifest, general_params
    self.pull primary_region, :dynamodb_list_tables, manifest, general_params
    self.pull primary_region, :dynamodbstreams_list_streams, manifest, general_params
    self.pull primary_region, :ec2_describe_vpcs, manifest, general_params
    self.pull primary_region, :ec2_describe_subnets, manifest, general_params
    self.pull primary_region, :ec2_describe_route_tables, manifest, general_params
    self.pull primary_region, :ec2_describe_internet_gateways, manifest, general_params
    self.pull primary_region, :ec2_describe_security_groups, manifest, general_params
    self.pull primary_region, :ec2_describe_route_tables, manifest, general_params
    self.pull primary_region, :ecr_describe_repositories, manifest, general_params
    self.pull primary_region, :ecs_describe_clusters, manifest, general_params
    self.pull primary_region, :ecs_list_task_definitions, manifest, general_params
    self.pull primary_region, :elbv2_describe_load_balancers, manifest, general_params
    self.pull primary_region, :elbv2_describe_target_groups, manifest, general_params
    self.pull primary_region, :lambda_list_functions, manifest, general_params
    self.pull primary_region, :lambda_list_layers, manifest, general_params
    self.pull primary_region, :rds_describe_db_instances, manifest, general_params
    self.pull primary_region, :rds_describe_db_subnet_groups, manifest, general_params
    self.pull primary_region, :rds_describe_db_snapshots, manifest, general_params
    self.pull primary_region, :route53_list_hosted_zones, manifest, general_params
    self.pull primary_region, :servicediscovery_list_services, manifest, general_params
    self.pull primary_region, :servicediscovery_list_namespaces, manifest, general_params

    self.pull 'us-east-1', :acm_list_certificates, manifest, general_params

    self.pull 'global', :cloudfront_list_distributions, manifest, general_params
    self.pull 'global', :s3api_list_buckets, manifest, general_params

    # ============================================
    # Global Region Specific =====================
    # ============================================
    self.pull_specific('global',{
      command: 'cloudfront_get_distribution',
      params: {distribution_id: 'cloudfront_list_distributions'}
      filters: {
        aliases: [
          "#{specific_params.naked_domain_name}",
          "assets.#{specific_params.naked_domain_name}"
        ]
      }
    }, manifest, general_params)
    self.pull_specific('global',{
      command: 'cloudfront_list_invalidations',
      params: {distribution_id: 'cloudfront_list_distributions'}
    }, manifest, general_params)
    self.pull_specific('global',{
      command: 's3api_get_bucket_notification_configuration',
      params: {bucket: 's3api_list_buckets'}
    }, manifest, general_params)
    self.pull_specific('global',{
      command: 's3api_get_bucket_policy',
      params: {bucket: 's3api_list_buckets'}
    }, manifest, general_params)
    self.pull_specific('global',{
      command: 's3api_get_bucket_cors',
      params: {bucket: 's3api_list_buckets'}
    }, manifest, general_params)
    self.pull_specific('global',{
      command: 's3api_get_bucket_website',
      params: {bucket: 's3api_list_buckets'}
    }, manifest, general_params)
    self.pull_specific('global',{
      command: 's3api_get_public_access_block',
      params: {bucket: 's3api_list_buckets'}
    }, manifest, general_params)
    # ============================================
    # Primary Region Specific ====================
    # ============================================
    self.pull_specific(primary_region,{
      command: 'acm_describe_certificate',
      params: {certificate_arn: 'acm_list_certificates'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'apigatewayv2_get_authorizers',
      params: {app_id: 'apigatewayv2_get_apis'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'apigatewayv2_get_integrations',
      params: {app_id: 'apigatewayv2_get_apis'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'cloudformation_list_stack_resources',
      params: {stack_name: 'cloudformation_list_stacks'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'codepipeline_get_pipeline',
      params: {pipeline_name: 'codepipeline_list_pipelines'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'cognito_idp_describe_user_pool',
      params: {user_pool_id: 'cognito_idp_list_user_pools'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'cognito_idp_list_user_pool_clients',
      params: {user_pool_id: 'cognito_idp_list_user_pools'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'cognito_idp_list_users',
      params: {user_pool_id: 'cognito_idp_list_user_pools'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'dynamodb_describe_table',
      params: {table_name: 'dynamodb_list_tables'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'dynamodbstreams_describe_stream',
      params: {stream_arn: 'dynamodbstreams_list_streams' }
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'ecr_describe_images',
      params: {repository_name: 'ecr_describe_repositories'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'elbv2_describe_listeners',
      params: {load_balancer_arn: 'elbv2_describe_load_balancers'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'elbv2_describe_load_balancer_attributes',
      params: {load_balancer_arn: 'elbv2_describe_load_balancers'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'elbv2_describe_target_group_attributes',
      params: {target_group_arn: 'elbv2_describe_target_groups'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'lambda_get_function' ,
      params: {function_name: 'lambda_list_functions'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'route53_get_hosted_zone',
      params: {hosted_zone_id: 'route53_list_hosted_zones'}
    }, manifest, general_params)
    self.pull_specific(primary_region,{
      command: 'route53_list_resource_record_sets',
      params: {hosted_zone_id: 'route53_list_hosted_zones'}
    }, manifest, general_params)

    # Complex usecase
    complex = [
      {
        command: 'cognito_idp_describe_user_pool_client',
        params: {
          user_pool_id: 'cognito_idp_list_user_pools',
          client_id: 'cognito_idp_list_user_pool_clients'
        }
      },
      {
        command: 'ecs_describe_tasks',
        params: {
          cluster: 'ecs_describe_clusters',
          tasks: 'ecs_list_tasks' # requires family and cluster
        }
      },
      {
        command: 'ecs_list_tasks',
        params: {
          cluster: '',
          family: ''
        }
      },
      {
        command: 'elbv2_describe_rules'
      }
    ]
    # A list of up to 100 cluster names or full cluster Amazon Resource Name (ARN) entries. If you do not specify a cluster, the default cluster is assumed.
    # - ecs_describe_services
    manifest.write_file
    Cpbvt::Uploader.run(
      file_path: manifest.output_file, 
      object_key: manifest.object_key,
      aws_region: general_params.region,
      aws_access_key_id: general_params.aws_access_key_id,
      aws_secret_access_key: general_params.aws_secret_access_key,
      payloads_bucket: general_params.payloads_bucket
    )
  end # def self.run

  def self.pull(user_region,command,manifest,general_params)
    result = Cpbvt::Payloads::Aws::Runner.run command.to_s, general_params.to_h.merge({
      user_region: user_region
    })
    manifest.add_payload command.to_s, result
  end

  def self.pull_specific(user_region, command, manifest, general_params)
    # Specific Regional AWS Resources Commands
    Cpbvt::Payloads::Aws::Runner.iter_run!(
      manifest: manifest,
      command: rule[:command], 
      extractor_filters: rule[:filters],
      specific_params: rule[:params], 
      general_params: general_params.to_h.merge({
        user_region: user_region,
      })
    )
  end

  # - s3api_head_bucket
  # - s3api_get_head_object
  # - s3api_get_object
  # - s3api_list_objects_v2
end # class