class Cpbvt::Tester::AssertSelect
  def initialize(describe_key:, spec_key:, report:, data:, context:)
    @describe_key = describe_key
    @spec_key = spec_key
    @report = report
    @data = data
    @context = context

    self.evaluate
  end

  def evaluate
    @report.iter_start!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: 'assert_select'
    )

    found =
    @data.select do |data|
      #@self_before_instance_eval = eval("self", @context.binding)
      #instance_eval &@context, data
      @report.iter_add!(
        describe_key: @describe_key, 
        spec_key: @spec_key
      )
      @context.call(self,data)

      @report.iter_last(@describe_key,@spec_key).all?{|t| t[:status] == 'pass'}
    end

    if found.any?
      status = 'pass'
      @found_data = found
    else
      status = 'fail'
    end

    @report.iter_end!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      status: status
    )
  end

  def expects_any? data, key, label: nil, &block
    kind =
    if label
      "assert_select[#{self.iter_index}]:expects_any?:#{label}"
    else
      "assert_select[#{self.iter_index}]:expects_any?"
    end

    provided_value = data[key]
    data_payload = {
      key: key,
    }

    if provided_value.nil?
      self.iter_fail!(kind: kind, data: data_payload, message: 'any items was found to be nil')
      return self
    end

    any_value = provided_value.any? do |item|
      result = block.call(item)
    end

    if any_value
      self.iter_pass!(kind: kind, data: data_payload, message: 'any item was found')
    else
      self.iter_fail!(kind: kind, data: data_payload, message: 'any item was not found')
    end
    return self
  end

  def expects_eq data, key, expected_value
    kind =  "assert_select[#{self.iter_index}]:expects_eq"
    provided_value = data[key]
    data_payload = {
      key: key,
      provided_value: provided_value,
      expected_value: expected_value
    }
    if provided_value == expected_value
      self.iter_pass!(kind: kind, data: data_payload, message: 'value was equal to')
    else
      self.iter_fail!(kind: kind, data: data_payload, message: 'value was not equal to')
    end
    return self
  end

  def expects_true data, key
    value = data[key]
    kind =  "assert_select[#{self.iter_index}]:expects_true"
    data_payload = {
      key: key,
      provided_value: value
    }
    if value == true
      self.iter_pass!(kind: kind, data: data_payload, message: 'value was found to be true')
    else
      self.iter_fail!(kind: kind, data: data_payload, message: 'value was not found to be true')
    end
    return self
  end

  def expects_false data, key
    value = data[key]
    kind =  "assert_select[#{self.iter_index}]:expects_false"
    data_payload = {
      key: key,
      provided_value: value
    }
    if value == false
      self.iter_pass!(kind: kind, data: data_payload, message: 'value was found to be false')
    else
      self.iter_fail!(kind: kind, data: data_payload, message: 'value was not found to be false')
    end
    return self
  end

  def returns key
    kind =  "assert_select:returns"
    data = @found_data
    if key == :all || key.nil?
      self.pass! kind: kind, message: 'return all data', data: {
      }
      return data 
    end
    if !data.nil? && data.key?(key)
      self.pass!(
        kind: kind, 
        message: 'return all data with provided key', 
        data: { 
          provided_key: key
      })
      return data[key]
    else
      self.fail!(
        kind: kind, 
        message: 'failed to return data with provided key since key does not exist or data is nil', 
        data: {
          provided_key: key
        }
      )
    end
  end

  def pass! kind:, message:, data: {}
    @report.pass!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      message: message,
      data: data
    )
  end

  def fail! kind:, message:, data: {}
    @report.fail!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      message: message,
      data: data
    )
  end

  def iter_pass! kind:, message:, data: {}
    @report.iter_pass!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      message: message,
      data: data
    )
  end

  def iter_fail! kind:, message:, data: {}
    @report.iter_fail!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      message: message,
      data: data
    )
  end

  def iter_index
    @report.iter_index @describe_key, @spec_key
  end
end