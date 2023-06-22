class Cpbvt::Tester::Test
  attr_accessor :name,
                :pass_msg,
                :fail_msg,
                :status

  # status can be:
  # ready - ready to run 
  # pass - has ran and graded as passed
  # fail - has ran and graded as failed
  # skipped - never ran
  def initialize name
    @name = name
    @status = :ready # ready to run
  end

  def assert_cfn_resource stack_name, resource_type
  end

  def assert_load manifest_payload_key
    obj = AssertLoad.new(
      manifest_payload_key: manifest_payload_key
    )
    return obj
  end

  def assert_json data, *keys
    obj = AssertJson.new(

    )
    return
  end

  def set_pass_message pass
    @pass_msg = msg
  end

  def set_fail_message fail
    @fail = msg
  end
end