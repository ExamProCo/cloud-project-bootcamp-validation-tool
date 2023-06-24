class Cpbvt::Tester::Spec
  attr_accessor :describe,
                :key,
                :pass_msg,
                :fail_msg,
                :status,
                :report,
                :manifest,
                :specific_params,
                :general_params,
                :dynamic_params

  # status can be:
  # ready - ready to run 
  # pass - has ran and graded as passed
  # fail - has ran and graded as failed
  # skipped - never ran
  def initialize describe:, key:, context:
    @describe = describe
    @key = key.to_sym
    @status = :ready # ready to run
    @context = context
  end

  # The magic that makes our DSL work.
  def evaluate!(
      report,
      manifest,
      general_params, 
      specific_params, 
      dynamic_params
  )
    @report = report
    @report.add! self.describe.key, self.key
    @manifest = manifest
    @general_params = general_params
    @specific_params = specific_params
    @dynamic_params = dynamic_params
    @self_before_instance_eval = eval "self", @context.binding
    instance_eval &@context
  end

  def assert_cfn_resource stack_name, resource_type
    obj = Cpbvt::Tester::AssertCfnResource.new(
      describe_key: self.describe.key,
      spec_key: self.key,
      report: @report,
      manifest: @manifest,
      stack_name: stack_name,
      resource_type: resource_type
    )
    return obj
  end

  def assert_load manifest_payload_key, key=nil
    obj = Cpbvt::Tester::AssertLoad.new(
      describe_key: self.describe.key,
      spec_key: self.key,
      report: @report,
      manifest_payload_key: manifest_payload_key,
      manifest: @manifest,
      key: key
    )
    return obj
  end

  def assert_json data, *keys
    obj = Cpbvt::Tester::AssertJson.new(
      describe_key: self.describe.key,
      spec_key: self.key,
      report: @report,
      data: data,
      keys: keys
    )
    return obj
  end

  def set_pass_message msg
    @pass_msg = msg
  end

  def set_fail_message msg
    @fail = msg
  end

  def set_state_value key, value
    @dynamic_params.send("#{key}=", value)
  end
end