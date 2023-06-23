class AssertJson
  def initialize describe_key:, spec_key:, report:,data:, keys:
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

  def expects_eq value
    if @data == value
      self.pass!(
        kind: 'assert_json:expects_eq', 
        status: :pass, 
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
        status: :fail, 
        message: 'value was not equal to', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    end
  end

  def expects_gt value
    if @value.is_a?(Numeric) && @value > value
      self.pass!(
        kind: 'assert_json:expects_gt', 
        status: :pass, 
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
        status: :fail, 
        message: 'value was not greater than', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    end
  end

  def expects_match value
    if @value.is_a?(String) && @value.match(value)
      self.pass!(
        kind: 'assert_json:expects_match', 
        status: :pass, 
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
        status: :fail, 
        message: 'failed to match', 
        data: { 
          provided_value: value,
          actual_value: @value,
          json_path: @json_path
        }
      )
    end
  end

  def returns key
    data = @data
    if key == :all || key.nil?
      self.fail! kind: 'assert_json:return', status: :pass, message: 'return all data', data: {
        json_path: @json_path
      }
      return data 
    end
    if data.key?(key)
      self.pass! kind: 'assert_json:return', status: :pass, message: 'return all data with provided key', data: { 
        provided_key: key,
        json_path: @json_path + ".#{key}"
      }
      return data[key]
    else
      self.fail! kind: 'assert_json:return', status: :pass, message: 'failed to return data with provided key since key does not exist', data: {
        provided_key: key ,
        json_path: @json_path + ".#{key}"
      }
    end
  end

  def pass! kind:, status:, message:, data: {}
    @report.pass!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      status: status,
      message: message,
      data: data
    )
  end

  def fail! kind:, status:, message:, data: {}
    @report.fail!(
      describe_key: @describe_key, 
      spec_key: @spec_key,
      kind: kind,
      status: status,
      message: message,
      data: data
    )
  end
end