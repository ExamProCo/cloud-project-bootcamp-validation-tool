class Cpbvt::Tester::AssertFail < StandardError
  attr_reader :describe_key,
              :spec_key,
              :assert_data,
              :kind
  def initialize(
    msg="",
    describe_key,
    spec_key,
    kind,
    assert_data
  )
    @describe_key = describe_key
    @spec_key     = spec_key
    @assert_data  = assert_data
    @kind         = kind
    super(msg)
  end
end

class Cpbvt::Tester::Report
  def initialize
    @specs = {}
  end

  def add! describe_key, spec_key
    @specs[describe_key] ||= {}
    @specs[describe_key][spec_key] ||= []
  end

  def pass! describe_key:, spec_key:, kind:, message:, data: {}
    @specs[describe_key][spec_key].push({
      kind: kind,
      status: 'pass',
      message: message,
      data: data
    })
  end

  def fail! describe_key:, spec_key:, kind:, message:, data: {}
    @specs[describe_key][spec_key].push({
      kind: kind,
      status: 'fail',
      message: message,
      data: data
    })
    raise Cpbvt::Tester::AssertFail.new(
      message,
      describe_key,
      spec_key,
      kind,
      data
    )
  end

  def to_json
    @specs.to_json
  end
end