class Aws2023::Validations::Cicd
  def self.should_have_a_codepipeline(manifest:,specific_params:)
    cfn_stacks =  manifest.get_output!('cloudformation-list-stacks')
    resource_pipeline = Cpbvt::Payloads::Aws::Extractors::Cloudformation.cloudformation_list_stacks__by_stack_resource_type(
      cfn_stacks,
      'CrdCluster',
      "AWS::CodePipeline::Pipeline"
    )
    pipeline_name = resource_pipeline['PhysicalResourceId']

    if pipeline = manifest.get_output("codepipeline-get-pipeline__#{pipeline_name}")
      pname = pipeline['pipeline']['name']
      {result: {score: 10, message: "Found a pipeline: #{pipeline_name} via a CFN Stack called CrdCicd"},pipeline_name: pname}
    else
      {result: {score: 0, message: "Failed to find a pipeline via CFN stack called CrdCicd"},pipeline_name: false}
    end
  end # self.should_have_a_codepipeline

  def self.should_have_a_source_from_github(manifest:,specific_params:,pipeline_name:)
    pipeline = manifest.get_output!("codepipeline-get-pipeline__#{pipeline_name}")

    source_codestar_action = nil
    pipeline['pipeline']['stages'].find do |stage|
      stage['actions'].find do |action|
        found = action['actionTypeId']['provider'] == 'CodeStarSourceConnection'
        source_codestar_action = action if found
        found
      end
    end
    conf = source_codestar_action['configuration']

    github =  specific_params.github_full_repo_name

    action_valid = 
    conf['BranchName'] == 'prod' &&
    conf['FullRepositoryId'] == github

    if action_valid
      {result: {score: 10, message: "Found a CodeStar source action for Branch prod for the repo at: #{github}"}}
    else
      {result: {score: 0, message: "Failedto find a CodeStar source action for Branch prod for the repo at: #{github}"}}
    end
  end

  def self.should_have_a_build_stage(manifest:,specific_params:,pipeline_name:)
    pipeline = manifest.get_output!("codepipeline-get-pipeline__#{pipeline_name}")

    build_action = nil
    pipeline['pipeline']['stages'].find do |stage|
      stage['actions'].find do |action|
        found = action['actionTypeId']['provider'] == 'CodeBuild'
        build_action = action if found
        found
      end
    end
    project_name = build_action['configuration']['ProjectName']
    
    project = manifest.get_output!("codebuild-batch-get-projects__#{project_name}")
    project = project['projects'].first

    expected_tag =
    project['tags'].any? do |tag|
      tag['key'] == 'group'
      tag['value'] == 'cruddur-cicd'
    end

    valid_codebuild =
    project['source']['type'] == 'CODEPIPELINE' &&
    project['environment']['privilegedMode'] == true &&
    expected_tag

    if valid_codebuild
      {result: {score: 10, message: "Found a codebuild action within the codepipeline and the codebuild project has privledge mode with tag group:cruddur-cicid"}}
    else
      {result: {score: 0, message: "Failed to find a codebuild action within the codepipeline and the codebuild project has privledge mode with tag group:cruddur-cicid"}}
    end
  end

  def self.should_have_a_deploy_stage(manifest:,specific_params:,pipeline_name:)
    cfn_stacks =  manifest.get_output!('cloudformation-list-stacks')
    resource_cluster = Cpbvt::Payloads::Aws::Extractors::Cloudformation.cloudformation_list_stacks__by_stack_resource_type(
      cfn_stacks,
      'CrdCluster',
      "AWS::ECS::Cluster"
    )
    cluster_name = resource_cluster['PhysicalResourceId']
    # ----

    pipeline = manifest.get_output!("codepipeline-get-pipeline__#{pipeline_name}")

    deploy_action = nil

    pipeline['pipeline']['stages'].find do |stage|
      stage['actions'].find do |action|
        found = action['actionTypeId']['provider'] == 'ECS' &&
                action['actionTypeId']['category'] == 'Deploy'
        deploy_action = action if found
        found
      end
    end
    found_cluster = deploy_action['configuration']['ClusterName'] == cluster_name
    found_service = deploy_action['configuration']['ServiceName'] == 'backend-flask'

    if found_cluster && found_service
      {result: {score: 10, message: "Found a Deploy with ECS for backend-flask service within the CodePipeline stages"}}
    else
      {result: {score: 0, message: "Failed to find Deploy with ECS for backend-flask service within the CodePipeline stages"}}
    end

  end # def self.should_have_a_deploy_stage
end # class Aws2023::Validations::Cicd