class Cpbvt::Tester::Report
  def initialize
    @specs = []
  end

  def to_json
    @specs.to_json
  end
end