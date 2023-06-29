class Cpbvt::Tester::AssertFind
  def initialize(describe_key:, spec_key:, report:, data: {}, context:)
    unless data.is_a?(Array)
      raise "expected Array but got #{data.class.to_s}"
    end
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
      kind: 'assert_find'
    )

    found =
    @data.find do |data|
      #@self_before_instance_eval = eval("self", @context.binding)
      #instance_eval &@context, data
      @report.iter_add!(
        describe_key: @describe_key, 
        spec_key: @spec_key
      )
      @context.call(self,data)

      @report.iter_last(@describe_key,@spec_key).all?{|t| t[:status] == 'pass'}
    end

    if found
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

  def expects_match data, value
    kind =  "assert_find[#{self.iter_index}]:expects_match"
    if data.is_a?(String) && data.match(value)
      self.iter_pass!(
        kind: kind,
        message: 'matched as expected', 
        data: { 
          provided_value: data
        }
      )
    else
      self.iter_fail!(
        kind: kind,
        message: 'failed to match', 
        data: { 
          provided_value: value
        }
      )
    end
    return self
  end

  def expects_any? data, key=nil, label: nil, &block
    kind =
    if label
      "assert_find[#{self.iter_index}]:expects_any?:#{label}"
    else
      "assert_find[#{self.iter_index}]:expects_any?"
    end

    if key.nil?
      provided_value = data
      data_payload = {}
    else
      provided_value = data[key]
      data_payload = {
        key: key,
      }
    end

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

  def expects_gt data, *args 
    expected_value = args.pop
    key = nil
    key = args.first if args.count > 0
    kind = "assert_find[#{self.iter_index}]:expects_gt"
    if key.nil?
      provided_value = data
    else
      provided_value = data[key]
    end
    data_payload = {
      key: key,
      provided_value: provided_value,
      expected_value: expected_value
    }
    if provided_value > expected_value
      self.iter_pass!(kind: kind, data: data_payload, message: 'value was greater than')
    else
      self.iter_fail!(kind: kind, data: data_payload, message: 'value was not greater than')
    end
    return self
  end


  def expects_eq data, *args 
    expected_value = args.pop
    key = nil
    key = args.first if args.count > 0
    kind = "assert_find[#{self.iter_index}]:expects_eq"
    if key.nil?
      provided_value = data
    else
      provided_value = data[key]
    end
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

  def expects_true data, key=nil
    if key
      value = data[key]
      data_payload = {
        key: key,
        provided_value: value
      }
    else
      value = data
      data_payload = {
        provided_value: value
      }
    end
    kind =  "assert_find[#{self.iter_index}]:expects_true"
    if value == true
      self.iter_pass!(kind: kind, data: data_payload, message: 'value was found to be true')
    else
      self.iter_fail!(kind: kind, data: data_payload, message: 'value was not found to be true')
    end
    return self
  end

  def expects_false data, key
    value = data[key]
    kind =  "assert_find[#{self.iter_index}]:expects_false"
    data_payload = {
      key: key,
      provided_value: value
    }
    if value == false
      self.iter_pass!(kind: kind, data: data_payload, message: 'value was equal found to be false')
    else
      self.iter_fail!(kind: kind, data: data_payload, message: 'value was not found to be false')
    end
    return self
  end

  def returns key
    kind =  "assert_find:returns"
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