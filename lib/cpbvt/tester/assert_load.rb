class Cpbvt::Tester::AssertLoad
  # key (string) -
  # AWS often returns data with a single property
  # so for arrays we often will want to find a record
  # and need to specific the key that we'll be looking
  # at for data
  # eg
  # { "UserPools" => {} }
  def initialize(
    describe_key:,
    spec_key:,
    report:,
    manifest:,
    manifest_payload_key:,
    key: nil
  )
    @report = report
    @describe_key = describe_key
    @spec_key = spec_key
    @data_raw = nil

    # load data
    @data_raw = manifest.get_output(manifest_payload_key)
    self.assert! 'load_data', 

    # apply filter if has key
    if key
      self.assert! 'load_data_key'
      @data_first_filter = @data_raw[key]
    end
  end

  def find key, value
    data = @data_first_filter || @data_raw
    @data_found = data.find{|t| t[key] == value}
    return self
  end

  def returns key
    data = @data_found || @data_raw
    return data if key == :all
    return data[key]
  end

  def assert!
    @report.assert! @describe_key, @spec_key
  end
end
