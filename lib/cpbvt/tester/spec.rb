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

  def assert_eq data, key, expected_value
    provided_value = data[key]
    if provided_value == expected_value
      self.pass!(
        kind: 'spec:assert_eq', 
        message: 'value was equal to', 
        data: { 
          provided_value: provided_value,
          expected_value: expected_value
        }
      )
    else
      self.fail!(
        kind: 'spec:assert_eq',
        message: 'value was not equal to', 
        data: { 
          provided_value: provided_value,
          expected_value: expected_value
        }
      )
    end
    return self
  end

  def assert_include? data, key, expected_value
    provided_value = data[key]
    if provided_value.include?(expected_value)
      self.pass!(
        kind: 'spec:assert_include?', 
        message: 'value was included', 
        data: { 
          provided_value: provided_value,
          expected_value: expected_value
        }
      )
    else
      self.fail!(
        kind: 'spec:assert_include?',
        message: 'value was not included', 
        data: { 
          provided_value: provided_value,
          expected_value: expected_value
        }
      )
    end
    return self
  end

  def assert_not_nil data, label: nil
    if label.nil?
      kind = "assert_not_nil"
    else
      kind = "assert_not_nil:#{label}"
    end
    unless data.nil?
      @report.pass!(
        describe_key: self.describe.key,
        spec_key: self.key,
        kind: kind,
        message: "Found that it not nil as expected",
        data: {}
      )
    else
      @report.fail!(
        describe_key: self.describe.key,
        spec_key: self.key,
        kind: kind,
        message: "It was found to be nil",
        data: {}
      )
    end
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

  def assert_find data, &block
    obj = Cpbvt::Tester::AssertFind.new(
      describe_key: self.describe.key,
      spec_key: self.key,
      report: @report,
      data: data,
      context: block
    )
    return obj
  end

  def assert_select data, &block
    obj = Cpbvt::Tester::AssertSelect.new(
      describe_key: self.describe.key,
      spec_key: self.key,
      report: @report,
      data: data,
      context: block
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

  def pass! kind:, message:, data: {}
    @report.pass!(
      describe_key: self.describe.key, 
      spec_key: self.key,
      kind: kind,
      message: message,
      data: data
    )
  end

  def fail! kind:, message:, data: {}
    @report.fail!(
      describe_key: self.describe.key, 
      spec_key: self.key,
      kind: kind,
      message: message,
      data: data
    )
  end
end