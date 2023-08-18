class Cpbvt::Tester::Spec
  attr_accessor :describe,
                :key,
                :pass_msg,
                :fail_msg,
                :status,
                :report,
                :condition,
                :manifest,
                :specific_params,
                :general_params,
                :dynamic_params

  ## condition can be:
  # optional - it doesn't matter if you fail this spec
  # critical (default) if you fail this spec then you fail

  # status can be:
  # ready - ready to run 
  # pass - has ran and graded as passed
  # fail - has ran and graded as failed
  # skipped - never ran
  def initialize describe:, key:, condition:, context:
    @describe = describe
    @condition = condition
    @condition ||= 'normal'
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
    #begin
    instance_eval &@context
    #rescue => e
      #binding.pry
    #end
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

  def assert_start_with data, *args
    expected_value = args.pop
    key = nil
    key = args.first if args.length > 0
    kind = 'spec:start_with'

    provided_value = key ? data[key] : data

    payload_data = {
      provided_value: provided_value,
      expected_value: expected_value
    }
    if provided_value.start_with?(expected_value)
      self.pass!(kind: kind, message: 'value was equal to', data: payload_data)
    else
      self.fail!(kind: kind, message: 'value was not equal to', data: payload_data)
    end
    return self
  end

  def assert_end_with data, *args
    expected_value = args.pop
    key = nil
    key = args.first if args.length > 0
    kind = 'spec:end_with'

    provided_value = key ? data[key] : data

    payload_data = {
      provided_value: provided_value,
      expected_value: expected_value
    }
    if provided_value.end_with?(expected_value)
      self.pass!(kind: kind, message: 'value was equal to', data: payload_data)
    else
      self.fail!(kind: kind, message: 'value was not equal to', data: payload_data)
    end
    return self
  end

  def assert_eq data, *args
    expected_value = args.pop
    key = nil
    key = args.first if args.length > 0
    kind = 'spec:assert_eq'

    provided_value = key ? data[key] : data

    payload_data = {
      provided_value: provided_value,
      expected_value: expected_value
    }
    if provided_value == expected_value
      self.pass!(kind: kind, message: 'value was equal to', data: payload_data)
    else
      self.fail!(kind: kind, message: 'value was not equal to', data: payload_data)
    end
    return self
  end

  def assert_include? data, *args
    expected_value = args.pop
    key = nil
    key = args.first if args.length > 0

    kind = 'spec:assert_include?'
    provided_value = key ? data[key] : data

    payload_data = {
      provided_value: provided_value,
      expected_value: expected_value
    }
    if provided_value.include?(expected_value)
      self.pass!(kind: kind, message: 'value was included', data: payload_data)
    else
      self.fail!(kind: kind, message: 'value was not included', data: payload_data)
    end
    return self
  end

  def assert_not_nil data, label: nil
    kind =
    if label.nil?
      "assert_not_nil"
    else
      "assert_not_nil:#{label}"
    end
    unless data.nil?
      self.pass!(kind: kind, message: "Found that it not nil as expected", data: {})
    else
      self.fail!(kind: kind, message: "It was found to be nil", data: {})
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

  def passed!
    @report.passed!(
      describe_key: self.describe.key, 
      spec_key: self.key)
  end

  def failed!
    @report.failed!(
      describe_key: self.describe.key, 
      spec_key: self.key)
  end
end
