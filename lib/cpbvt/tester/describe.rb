class Cpbvt::Tester::Describe
  attr_accessor :key, :specs

  def initialize key:, context:
    @key = key
    @specs = {}
    self.evaluate! context
  end

  # The magic that makes our DSL work.
  def evaluate! context
    @self_before_instance_eval = eval "self", context.binding
    instance_eval &context
  end

  def spec key, &block
    key = key.to_sym
    # test is a revserved word which is why we say test_instances
    spec_instance = Cpbvt::Tester::Spec.new(
      describe: self,
      key: key,
      context: block
    )
    raise "spec key already in use: #{key}" if @specs.key?(key)
    @specs[key] = spec_instance
  end

  # We might want this later...
  # https://www.dan-manges.com/blog/ruby-dsls-instance-eval-with-delegation
  #def method_missing(method, *args, **kwargs, &block)
  #  @self_before_instance_eval.send method, *args, &block
  #end
end