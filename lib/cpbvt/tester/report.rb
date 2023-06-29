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
    @specs[describe_key][spec_key] ||= {status: nil, asserts: []}
  end

  def pass! describe_key:, spec_key:, kind:, message:, data: {}
    @specs[describe_key][spec_key][:asserts].push({
      kind: kind,
      status: 'pass',
      message: message,
      data: data
    })
  end

  def fail! describe_key:, spec_key:, kind:, message:, data: {}
    @specs[describe_key][spec_key][:asserts].push({
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

  def passed! describe_key:, spec_key:
    @specs[describe_key][spec_key][:status] = 'pass'
  end

  def failed! describe_key:, spec_key:
    @specs[describe_key][spec_key][:status] = 'fail'
  end

  # only for iter
  def iter_index describe_key, spec_key
    @specs[describe_key][spec_key][:asserts].last[:results].size-1
  end

  def iter_add!(describe_key:,spec_key:)
    @specs[describe_key][spec_key][:asserts].last[:results].push []
  end

  def iter_start!(describe_key:, spec_key:, kind:)
    @specs[describe_key][spec_key][:asserts].push({
      kind: kind,
      status: 'unknown',
      message: nil,
      results: [],
      data: nil
    })
  end

  def iter_end!(describe_key:, spec_key:,status:,data:{})
    spec = @specs[describe_key][spec_key][:asserts].last
    spec[:status] = status
    spec[:data] = data
  end

  def iter_pass! describe_key:, spec_key:, kind:, message:, data: {}
    spec = @specs[describe_key][spec_key][:asserts].last
    spec[:results].last.push({
      kind: kind,
      status: 'pass',
      message: message,
      data: data
    })
  end

  def iter_fail! describe_key:, spec_key:, kind:, message:, data: {}
    spec = @specs[describe_key][spec_key][:asserts].last
    spec[:results].last.push({
      kind: kind,
      status: 'fail',
      message: message,
      data: data
    })
    # we don't raise an error here
  end

  def iter_last describe_key, spec_key
    spec = @specs[describe_key][spec_key][:asserts].last[:results].last
  end

  def to_json
    @specs.to_json
  end
end