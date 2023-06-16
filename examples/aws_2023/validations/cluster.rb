class Aws2023::Validations::Cluster
  def self.should_have_a_cluster(manifest:,specific_params:)

    resource_cluster = Cpbvt::Payloads::Aws::Extractor.cloudformation_list_stacks__by_stack_resource_type(
      manifest,
      'CrdCluster',
      "AWS::ECS::Cluster"
    )
    cluster_name = resource_cluster['PhysicalResourceId']

    clusters = manifest.get_output!('ecs-describe-clusters')
    cluster = clusters['clusters'].find do |t| 
      t['clusterName'] == cluster_name
    end

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

    if found
      {result: {score: 10, message: "Found a task defintition with a family: #{specific_params.backend_family}"}}
    else
      {result: {score: 0, message: "Failed to find a task defintition with a family: #{specific_params.backend_family}"}}
    end
  end

  def self.should_have_a_service(manifest:,specific_params:)
    cluster_name = specific_params.cluster_name
    data = manifest.get_output!("ecs-list-services__#{cluster_name}")
  end

  def self.should_have_a_running_task(manifest:,specific_params:)
  end

  def self.should_have_an_alb(manifest:,specific_params:)
  end

  def self.should_have_alb_sg(manifest:,specific_params:)
  end

  def self.should_have_service_sg(manifest:,specific_params:)
  end

end