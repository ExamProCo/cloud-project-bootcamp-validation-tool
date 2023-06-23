class AssertJson
  def initialize describe_key:, spec_key:, report:,data:, keys:
    keys.each do |key|
      data = data[key]
    end
    @data = data
    return self
  end

  def expects_eq value
    @data == value
  end

  def expects_gt number
    @data > number
  end

  def expects_match value
    @data.match(value)
  end

  def returns key=nil
    return @data if key == :all || key.nil?
    return @data[key]
  end
end