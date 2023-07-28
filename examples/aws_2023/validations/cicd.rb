Cpbvt::Tester::Runner.describe :cicd do |t|
  spec :should_have_a_codepipeline do |t|
    pipeline_name = assert_cfn_resource(t.specific_params.cfn_stack_name_cicd,"AWS::CodePipeline::Pipeline").returns('PhysicalResourceId')
    pipeline_name2 = assert_load("codepipeline-get-pipeline__#{pipeline_name}",'pipeline').returns('name')

    set_pass_message "Found a pipeline: #{pipeline_name} via a CFN Stack called CrdCicd"
    set_fail_message "Failed to find a pipeline via CFN stack called CrdCicd"

    set_state_value :pipeline_name, pipeline_name2
  end # self.should_have_a_codepipeline

  spec :should_have_a_source_from_github do |t|
    github = t.specific_params.github_full_repo_name
    pipeline_name = t.dynamic_params.pipeline_name
    pipeline = assert_load("codepipeline-get-pipeline__#{pipeline_name}",'pipeline').returns(:all)

    assert_json(pipeline,'stages').expects_not_nil

    source_codestar_action = nil
    pipeline['stages'].each do |stage|
      source_codestar_action =
      stage['actions'].find do |action|
        if action['actionTypeId']['provider'] == 'CodeStarSourceConnection'
          source_codestar_action = action
        end
      end
      break if source_codestar_action
    end

    assert_not_nil(source_codestar_action)

    assert_json(source_codestar_action,'configuration','BranchName').expects_eq('prod')
    assert_json(source_codestar_action,'configuration','FullRepositoryId').expects_eq(github)

    set_pass_message "Found a CodeStar source action for Branch prod for the repo at: #{github}"
    set_fail_message "Failed to find a CodeStar source action for Branch prod for the repo at: #{github}"
  end

  spec :should_have_a_build_stage do |t|
    pipeline_name = t.dynamic_params.pipeline_name
    pipeline = assert_load("codepipeline-get-pipeline__#{pipeline_name}",'pipeline').returns(:all)

    assert_json(pipeline,'stages').expects_not_nil

    build_action = nil
    pipeline['stages'].each do |stage|
      source_codestar_action =
      stage['actions'].find do |action|
        if action['actionTypeId']['provider'] == 'CodeBuild'
          build_action = action
        end
      end
      break if build_action
    end

    assert_not_nil(build_action)

    project_name = assert_json(build_action,'configuration').returns('ProjectName')
    
    project = assert_load("codebuild-batch-get-projects__#{project_name}",'projects').returns(:first)

    tags = assert_json(project,'tags').returns(:all)

    tag =
    assert_find(tags) do |assert, tag|
      assert.expects_eq(tag,'key','group')
      assert.expects_eq(tag,'value','cruddur-cicd')
    end.returns(:all)

    assert_not_nil(tag)

    assert_json(project,'source','type').expects_eq('CODEPIPELINE')
    assert_json(project,'environment','privilegedMode').expects_true

    set_pass_message "Found a codebuild action within the codepipeline and the codebuild project has privledge mode with tag group:cruddur-cicid"
    set_fail_message "Failed to find a codebuild action within the codepipeline and the codebuild project has privledge mode with tag group:cruddur-cicid"
  end

  spec :should_have_a_deploy_stage do |t|
    cluster_name = t.specific_params.cluster_name
    pipeline_name = t.dynamic_params.pipeline_name
    pipeline = assert_load("codepipeline-get-pipeline__#{pipeline_name}",'pipeline').returns(:all)

    assert_json(pipeline,'stages').expects_not_nil

    deploy_action = nil
    pipeline['stages'].each do |stage|
      source_codestar_action =
      stage['actions'].find do |action|
        if action['actionTypeId']['provider'] == 'ECS' &&
           action['actionTypeId']['category'] == 'Deploy'
          deploy_action = action
        end
      end
      break if deploy_action
    end
 
    assert_not_nil(deploy_action)

    assert_json(deploy_action,'configuration','ClusterName').expects_eq(cluster_name)
    assert_json(deploy_action,'configuration','ServiceName').expects_eq('backend-flask')

    set_pass_message "Found a Deploy with ECS for backend-flask service within the CodePipeline stages"
    set_fail_message "Failed to find Deploy with ECS for backend-flask service within the CodePipeline stages"
  end # def self.should_have_a_deploy_stage
end # class Aws2023::Validations::Cicd