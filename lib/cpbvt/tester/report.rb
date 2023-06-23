class Cpbvt::Tester::Report
  def initialize
    @specs = []
  end

  def add! describe_key, spec_key
    @specs[describe_key] ||= {}
    @specs[describe_key][spec_key] ||= []
  end

  def assert! describe_key, spec_key
    @specs[describe_key][spec_key]
  end

  def to_json
    @specs.to_json
  end
end