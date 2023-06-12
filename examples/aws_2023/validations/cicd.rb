class Aws2023::Validations::Cicd
  # CI/CD Validation
    # should have a codepipeline
    # with a source from github to the expected bootcamp repo
    # with a build step to codebuild
    # with deployment using ECS deployer
  def self.should_have_a_codepipeline(manifest:)
    puts manifest.payload_keys
    cfn_stacks =  manifest.get_output!('cloudformation-list-stacks')
    # Find the stack for CICD
    cicd_stack = cfn_stacks['StackSummaries'].find do |stack|
      stack['StackName'] == 'CrdCicd'
    end
    # extract the stack id
    cicd_stack_id = cicd_stack['StackId'].split('/').last

    cicd_stack_resources = manifest.get_output!("cloudformation-list-stack-resources__#{cicd_stack_id}")
    resource_pipeline = cicd_stack_Resources['StackResourceSummaries'].find do |resource|
      resource["ResourceType"] == "AWS::CodePipeline::Pipeline"
    end

    pipeline_name = resource_pipeline['PhysicalResourceId']

    if pipeline = manifest.get_output("codepipelines-get-pipeline__#{pipeline_name}")
      {result: {score: 10, message: "Found a pipeline: #{pipeline_name} via a CFN Stack called CrdCicd"},pipeline_id: pipeline['Name']}
    else
      {result: {score: 0, message: "Failed to find a pipeline via CFN stack called CrdCicd"},pipeline_id: false}
    end

  end
end