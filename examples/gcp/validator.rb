class Gcp::Validator
  def self.run(
    validations_path:,
    general_params:,
    specific_params:,
    dynamic_params:,
    load_order: []
  )
    unless general_params.valid?
      puts general_params.errors.full_messages
      raise "failed to pass general params validation"
    end

    unless specific_params.valid?
      puts specific_params.errors.full_messages
      raise "failed to specific params validation"
    end

    state = Gcp::State.new

    manifest = Cpbvt::Manifest.new(
      user_uuid: general_params.user_uuid,
      run_uuid: general_params.run_uuid,
      output_path: general_params.output_path,
      project_scope: general_params.project_scope,
      payloads_bucket: general_params.payloads_bucket
    )
    manifest.load_from_file!
    manifest.pull!

    Cpbvt::Tester::Runner.run!(
      validations_path: validations_path,
      load_order: load_order,
      manifest: manifest,
      general_params: general_params,
      specific_params: specific_params,
      dynamic_params: dynamic_params
    )
  end # def self.run
end