class Aws2023::Validations::Cluster
  def self.should_have_a_cluster(manifest:,specific_params:)
    resource_cluster = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdCluster',
      "AWS::ECS::Cluster"
    )
    cluster_name = resource_cluster['PhysicalResourceId']

    clusters = manifest.get_output!("ecs-describe-clusters__#{cluster_name}")
    cluster = clusters['clusters'].first

    found =
    cluster['status'] == 'ACTIVE' &&
    cluster['capacityProviders'].include?('FARGATE')

    if found
      {result: {score: 10, message: "Found a cluster: #{cluster_name} that is ACTIVE for FARGATE"}}
    else
      {result: {score: 0, message: "Failed to find a cluster that is ACTIVE for FARGATE"}}
    end
  end

  def self.should_have_a_task_definition(manifest:,specific_params:)
    data = manifest.get_output!('ecs-list-task-definitions')
    found =
    data['taskDefinitionArns'].any? do |arn|
      arn.match(specific_params.backend_family)
    end

    if found
      {result: {score: 10, message: "Found a task defintition with a family: #{specific_params.backend_family}"}}
    else
      {result: {score: 0, message: "Failed to find a task defintition with a family: #{specific_params.backend_family}"}}
    end
  end

  def self.should_have_an_ecr_repo(manifest:,specific_params:)
    data = manifest.get_output!('ecr-describe-repositories')
    repo = data['repositories'].find{|t| t['repositoryName'] == specific_params.backend_family}
    # [TODO] Check if images are present in the container repo

    if repo
      {result: {score: 10, message: "Found a task defintition with a family: #{specific_params.backend_family}"}}
    else
      {result: {score: 0, message: "Failed to find a task defintition with a family: #{specific_params.backend_family}"}}
    end
  end

  def self.should_have_a_service(manifest:,specific_params:)
    cluster_name = specific_params.cluster_name
    data = manifest.get_output!("ecs-describe-services__#{cluster_name}")
    backend_service = data['services'].find{|t|t['serviceName'] == specific_params.backend_family}

    found = backend_service['status'] == 'ACTIVE'

    if found
      {result: {score: 10, message: "Found a fargate service a #{specific_params.backend_family}"}}
    else
      {result: {score: 0, message: "Failed to find a fargate service a #{specific_params.backend_family}"}}
    end
  end

  def self.should_have_a_running_task(manifest:,specific_params:)
    cluster_name = specific_params.cluster_name
    data = manifest.get_output!("ecs-describe-tasks")

    container = nil
    data['tasks'].each do |task|
      if task['clusterArn'].match(cluster_name)
        container = task['containers'].find do |container|
          container['name'] == specific_params.backend_family
        end
        if container
          break
        end
      end
    end

    healthy = container['healthStatus'] == 'HEALTHY'

    if healthy
      {result: {score: 10, message: "Found an ECS task for: #{specific_params.backend_family} running in the expected cluster and service that is HEALTHY"}}
    else
      {result: {score: 0, message: "Failed to find an ECS task for: #{specific_params.backend_family} running in the expected cluster and service that is HEALTHY"}}
    end
  end

  def self.should_have_an_alb(manifest:,specific_params:)
    cluster_name = specific_params.cluster_name
    service_name = specific_params.backend_family
    data = manifest.get_output!("ecs-describe-services__#{cluster_name}")
    backend_service = data['services'].find{|t|t['serviceName'] == service_name}

    if backend_service.key?('loadBalancers')
      found = backend_service['loadBalancers'].first['containerPort'] = 4567
      if found 
        {result: {score: 10, message: "Found attached load balancer for the fargate service: #{service_name}"}}
      else
        {result: {score: 5, message: "Failed to find an attached load balancer for the fargate service: #{service_name} for port 4567"}}
      end
    else
      {result: {score: 0, message: "Failed to find an attached load balancer for the fargate service: #{service_name}"}}
    end
  end

  def self.should_have_alb_sg(manifest:,specific_params:)
  end

  def self.should_have_service_sg(manifest:,specific_params:)
  end

end