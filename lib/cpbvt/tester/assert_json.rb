class Cpbvt::Tester::AssertJson
  def initialize(describe_key:, spec_key:, report:,data:, keys:)
    unless data.is_a?(Hash)
      raise "expected Hash but got #{data.class.to_s}"
    end
    @json_path = []
    @describe_key = describe_key
    @spec_key = spec_key
    @report = report
    value = data
    keys.each do |key|
      if value.key?(key)
        @json_path.push key
        value = value[key]
      else
        value = nil
        break
      end
    end
    @json_path = @json_path.join('.')
    @value = value
    return self
  end

  def expects_true
    kind =  "assert_json:expects_true"
    data_payload = {}
    if @value == true
      self.pass!(kind: kind, data: data_payload, message: 'value was found to be true')
    else
      self.fail!(kind: kind, data: data_payload, message: 'value was not found to be true')
    end
    return self
  end

  def expects_false
    kind =  "assert_json:expects_false"
    data_payload = {}
    if @value == false
      self.pass!(kind: kind, data: data_payload, message: 'value was equal found to be false')
    else
      self.fail!(kind: kind, data: data_payload, message: 'value was not found to be false')
    end
    return self
  end

  def expects_start_with value
    kind =  "assert_json:expects_start_with"
    data_payload = {
      expected_start_with: value
    }
    if @value.start_with?(value)
      self.pass!(kind: kind, data: data_payload, message: 'value was found to start with')
    else
      self.fail!(kind: kind, data: data_payload, message: 'value did not start with')
    end
    return self
  end

  def expects_end_with value
    kind =  "assert_json:expects_end_with"
    data_payload = {
      expected_end_with: value
    }
    if @value.end_with?(value)
      self.pass!(kind: kind, data: data_payload, message: 'value was found to end with')
    else
      self.fail!(kind: kind, data: data_payload, message: 'value did not end with')
    end
    return self
  end

  def expects_eq value
    if @value == value
      self.pass!(
        kind: 'assert_json:expects_eq', 
        message: 'value was equal to', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    else
      self.fail!(
        kind: 'assert_json:expects_eq',
        message: 'value was not equal to', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    end
    return self
  end

  def expects_gt value
    if @value.is_a?(Numeric) && @value > value
      self.pass!(
        kind: 'assert_json:expects_gt', 
        message: 'value was greater than', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    else
      self.fail!(
        kind: 'assert_json:expects_match',
        message: 'value was not greater than', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    end
    return self
  end

  def expects_match value
    if @value.is_a?(String) && @value.match(value)
      self.pass!(
        kind: 'assert_json:expects_match', 
        message: 'matched as expected', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    else
      self.fail!(
        kind: 'assert_json:expects_match',
        message: 'failed to match', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    end
    return self
  end

  def expects_not_nil
    unless @value.nil?
      self.pass!(
        kind: 'assert_json:expects_not_nil', 
        message: 'value was found to be not nil', 
        data: { 
          actual_value: @value,
          json_path: @json_path
        }
      )
    else
      self.fail!(
        kind: 'assert_json:expects_not_nil',
        message: 'failed since value is nil', 
        data: { 
          actual_value: @value,
          json_path: @json_path
        }
      )
    end
    return self
  end

  def returns key
    data = @value
    if key == :all || key.nil?
      self.pass! kind: 'assert_json:returns', message: 'return all data', data: {
        json_path: @json_path
      }
      return data 
    end
    if key == :first
      if data.is_a?(Array) && data.count > 0
        self.pass!(
          kind: 'assert_json:returns',
          message: 'returns first record'
        )
        return data.first
      else
        self.fail!(
          kind: 'assert_json:returns',
          message: 'failed to return first record'
        )
      end
    end
    if data.key?(key)
      self.pass! kind: 'assert_json:returns', message: 'return all data with provided key', data: { 
        provided_key: key,
        json_path: @json_path + ".#{key}"
      }
      return data[key]
    else
      self.fail! kind: 'assert_json:returns', message: 'failed to return data with provided key since key does not exist', data: {
        provided_key: key ,
        json_path: @json_path + ".#{key}"
      }
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
end
