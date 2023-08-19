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

  def add! describe_key, spec_key, condition
    @specs[describe_key] ||= {specs: {}}
    @specs[describe_key][:specs][spec_key] ||= {status: nil, asserts: [], condition: condition}
  end

  def pass! describe_key:, spec_key:, kind:, message:, data: {}
    @specs[describe_key][:specs][spec_key][:asserts].push({
      kind: kind,
      status: 'pass',
      message: message,
      data: data
    })
  end

  def fail! describe_key:, spec_key:, kind:, message:, data: {}
    @specs[describe_key][:specs][spec_key][:asserts].push({
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
    @specs[describe_key][:specs][spec_key][:status] = 'pass'
  end

  def failed! describe_key:, spec_key:
    @specs[describe_key][:specs][spec_key][:status] = 'fail'
  end

  # only for iter
  def iter_index describe_key, spec_key
    @specs[describe_key][:specs][spec_key][:asserts].last[:results].size-1
  end

  def iter_add!(describe_key:,spec_key:)
    @specs[describe_key][:specs][spec_key][:asserts].last[:results].push []
  end

  def iter_start!(describe_key:, spec_key:, kind:)
    @specs[describe_key][:specs][spec_key][:asserts].push({
      kind: kind,
      status: 'unknown',
      message: nil,
      results: [],
      data: nil
    })
  end

  def iter_end!(describe_key:, spec_key:,status:,data:{})
    spec = @specs[describe_key][:specs][spec_key][:asserts].last
    spec[:status] = status
    spec[:data] = data
  end

  def iter_pass! describe_key:, spec_key:, kind:, message:, data: {}
    spec = @specs[describe_key][:specs][spec_key][:asserts].last
    spec[:results].last.push({
      kind: kind,
      status: 'pass',
      message: message,
      data: data
    })
  end

  def iter_fail! describe_key:, spec_key:, kind:, message:, data: {}
    spec = @specs[describe_key][:specs][spec_key][:asserts].last
    spec[:results].last.push({
      kind: kind,
      status: 'fail',
      message: message,
      data: data
    })
    # we don't raise an error here
  end

  def iter_last describe_key, spec_key
    spec = @specs[describe_key][:specs][spec_key][:asserts].last[:results].last
  end

  def to_json
    total_spec_count = 0
    total_spec_pass_count = 0
    total_assert_count = 0
    total_assert_pass_count = 0
    status = 'pass'

    @specs.each do |group_name,group|
      group[:spec_pass_count] = 0
      total_spec_count += group[:specs].count
      group[:specs].each do |spec_name,spec|
        total_assert_count += spec[:asserts].count
        spec[:assert_pass_count] = 0
        if spec[:status] == 'pass'
          group[:spec_pass_count] += 1
          total_spec_pass_count += 1
        elsif spec[:status] == 'fail' && spec[:condition] != 'optional'
          status = 'fail'
        end
        spec[:asserts].each do |assert_obj|
          if assert_obj[:status] == 'pass'
            spec[:assert_pass_count] += 1
            total_assert_pass_count += 1
          end
        end # spec[:asserts]
      end # group[:specs]
    end

    report = {
      status: status,
      total_spec_count: total_spec_count,
      total_spec_pass_count: total_spec_pass_count,
      total_assert_count: total_assert_count,
      total_assert_pass_count: total_assert_pass_count,
      describes: @specs
    }
    report.to_json
  end
end
