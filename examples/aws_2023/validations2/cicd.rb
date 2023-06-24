Cpbvt::Tester::Runner.describe :cicd do |t|
  spec :should_have_a_codepipeline do |t|
    pipeline_name = assert_cfn_resource('CrdCicd',"AWS::CodePipeline::Pipeline").returns('PhysicalResourceId')
    pipeline_name2 = assert_load("codepipeline-get-pipeline__#{pipeline_name}").returns('name')

    set_pass_message "Found a pipeline: #{pipeline_name} via a CFN Stack called CrdCicd"
    set_fail_message "Failed to find a pipeline via CFN stack called CrdCicd"

    #set_state_value :pipeline_name, pipeline_name2
  end # self.should_have_a_codepipeline

  spec :should_have_a_source_from_github do |t|
    # t.specific_params.github_full_repo_name
    # t.dynamic_params.pipeline_name
    #pipeline = assert_load("codepipeline-get-pipeline__#{pipeline_name}").returns(:all)

    #source_codestar_action =
    #assert_json(pipeline,'pipeline','stages').find_and_returns do |stage|
    #  stage['actions'].find do |action|
    #    if action['actionTypeId']['provider'] == 'CodeStarSourceConnection'
    #      return_result action
    #    end
    #  end
    #end
    #assert_json(source_codestar_action,'configuration','BranchName').expects_eq('prod')
    #assert_json(source_codestar_action,'configuration','FullRepositoryId').expects_eq(github_full_repo_name)

    #set_pass_message "Found a CodeStar source action for Branch prod for the repo at: #{github_full_repo_name}"
    #set_fail_message "Failedto find a CodeStar source action for Branch prod for the repo at: #{github_full_repo_name}"
  end

  spec :should_have_a_build_stage do |t|
    # t.dynamic_params.pipeline_name
    #pipeline = assert_load("codepipeline-get-pipeline__#{pipeline_name}")

    #build_action =
    #assert_json(pipeline,'pipeline','stages').find_and_returns do |stage|
    #  stage['actions'].find do |action|
    #    if action['actionTypeId']['provider'] == 'CodeBuild'
    #      return_result action
    #    end
    #  end
    #end

    #project_name = assert_json(build_action,'configuration').returns('ProjectName')
    
    #projects = assert_load("codebuild-batch-get-projects__#{project_name}").returns('projects')
    #project = projects.first

    #assert_json(project,'tags').expects_any? do |tag|
    #  expects_json(tag,'key').eq('group')
    #  expects_json(tag,'value').eq('cruddur-cicd')
    #end

    #expects_json(project,'source','type').epects_eq('CODEPIPELINE')
    #expects_json(project,'environment','privilegedMode').expects_true

    #set_pass_message "Found a codebuild action within the codepipeline and the codebuild project has privledge mode with tag group:cruddur-cicid"
    #set_fail_message "Failed to find a codebuild action within the codepipeline and the codebuild project has privledge mode with tag group:cruddur-cicid"
  end

  spec :should_have_a_deploy_stage do |t|
    # t.dynamic_params.pipeline_name
    #cluster_name = assert_cfn_resource('CrdCluster',"AWS::ECS::Cluster").returns('PhysicalResourceId')
    #pipeline = assert_load!("codepipeline-get-pipeline__#{pipeline_name}")

    #deploy_action = nil

    #pipeline['pipeline']['stages'].find do |stage|
    #  stage['actions'].find do |action|
    #    found = action['actionTypeId']['provider'] == 'ECS' &&
    #            action['actionTypeId']['category'] == 'Deploy'
    #    deploy_action = action if found
    #    found
    #  end
    #end

    #deploy_action =
    #assert_json(pipeline,'pipeline','stages').find_and_returns do |stage|
    #  stage['actions'].find do |action|
    #    if action['actionTypeId']['provider'] == 'ECS' &&
    #       action['actionTypeId']['category'] == 'Deploy'
    #      return_result action
    #    end
    #  end
    #end
 
    #assert_json(deploy_action,'configuration','ClusterName').expects_eq(cluster_name)
    #assert_json(deploy_action,'configuration','ServiceName').expects_eq('backend-flask')

    #set_pass_message "Found a Deploy with ECS for backend-flask service within the CodePipeline stages"
    #set_fail_message "Failed to find Deploy with ECS for backend-flask service within the CodePipeline stages"
  end # def self.should_have_a_deploy_stage
end # class Aws2023::Validations::Cicd