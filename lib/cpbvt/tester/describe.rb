class Cpbvt::Tester::Describe
  attr_accessor :key, :context

  def initialize key, context
    @key = key
    @context = context
  end
end