class Aws2023::Validations::Cluster
  def self.should_have_a_cluster(manifest:,specific_params:)
    cfn_stacks =  manifest.get_output!('cloudformation-list-stacks')
    resource_cluster = Cpbvt::Payloads::Aws::Extractors::Cloudformation.cloudformation_list_stacks__by_stack_resource_type(
      cfn_stacks,
      'CrdCluster',
      "AWS::ECS::Cluster"
    )
    cluster_name = resource_cluster['PhysicalResourceId']

    cluster = manifest.get_output!('')
  end

  def self.should_have_a_task_defintion(manifest:,specific_params:)
  end

  def self.should_have_an_ecr_repo(manifest:,specific_params:)
  end

  def self.should_have_a_service(manifest:,specific_params:)
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