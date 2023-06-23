class Cpbvt::Tester::Spec
  attr_accessor :key,
                :pass_msg,
                :fail_msg,
                :status

  # status can be:
  # ready - ready to run 
  # pass - has ran and graded as passed
  # fail - has ran and graded as failed
  # skipped - never ran
  def initialize key:, context:
    @key = key.to_sym
    @status = :ready # ready to run
    @context = context
  end

  # The magic that makes our DSL work.
  def evaluate! state
    @state = state
    @self_before_instance_eval = eval "self", @context.binding
    instance_eval &@context
  end

  def assert_cfn_resource stack_name, resource_type
  end

  def assert_load manifest_payload_key
    obj = Cpbvt::Tester::AssertLoad.new(
      manifest_payload_key: manifest_payload_key,
      manifest: @state.manifest
    )
    return obj
  end

  def assert_json data, *keys
    #obj = AssertJson.new(

    #)
    #return
  end

  def set_pass_message pass
    @pass_msg = msg
  end

  def set_fail_message fail
    @fail = msg
  end
end