require 'pp'

class Aws2023::Validator2

  def self.run(general_params:,specific_params:)
    unless general_params.valid?
      puts general_params.errors.full_messages
      raise "failed to pass general params validation"
    end

    unless specific_params.valid?
      puts specific_params.errors.full_messages
      raise "failed to specific params validation"
    end

    state = Aws2023::State.new

    manifest = Cpbvt::Manifest.new(
      user_uuid: general_params.user_uuid,
      run_uuid: general_params.run_uuid,
      output_path: general_params.output_path,
      project_scope: general_params.project_scope,
      payloads_bucket: general_params.payloads_bucket
    )
    manifest.load_from_file!
    manifest.pull!
    state.manifest = manifest
    state.specific_params = specific_params

    Cpbvt::Tester::Runner.run!(
      state: state,
      validations_path: "/workspace/cloud-project-bootcamp-validation-tool/examples/aws_2023/validations2"
    )

    #self.networking_validations state
    #self.cluster_validations state
    #self.cicd_validations state
    #self.iac_validations state
    #self.static_website_hosting_validations state
    #self.db_validations state
    #self.ddb_validations state
    #self.serverless_validations state
    #self.authenication_validations state

    #pp state.results
  end # def self.run
end # class