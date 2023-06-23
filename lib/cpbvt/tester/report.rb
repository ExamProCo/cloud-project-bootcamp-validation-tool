class Cpbvt::Tester::AssertFail < StandardError
  def initialize(
    msg="",
    describe_key,
    spec_key,
    kind,
    status,
    assert_data
  )
    @describe_key = describe_key
    @spec_key     = spec_key
    @assert_data  = assert_data
    @kind         = kind
    @status       = status
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

  def pass! describe_key:, spec_key:, kind:, status:, message:, data: {}
    @specs[describe_key][spec_key].push({
      kind: kind,
      status: status,
      message: message,
      data: data
    })
  end

  def fail! describe_key:, spec_key:, kind:, status:, message:, data: {}
    @specs[describe_key][spec_key].push({
      kind: kind,
      status: status,
      message: message,
      data: data
    })
    raise Cpbvt::Tester::AssertFail.new(
      message,
      describe_key,
      spec_key,
      kind,
      status,
      data
    )
  end

  def to_json
    @specs.to_json
  end
end