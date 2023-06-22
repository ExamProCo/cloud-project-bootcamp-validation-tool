class Cpbvt::Tester::Runner
  @@describes = {}
  @@loaded = false

  def self.run! validations_path
    unless @loadded
      path = File.join(validations_path,".rb")
      Dir.glob(path).each do |path|
        require path
      end
    end
    binding.pry
  end

  def self.describe key, &block
    describe = Cpbvt::Tester::Describe.new(
      key: key,
      block: block
    )
    raise "describe key already in use:# {key}" if @@describe.key?(key)
    @@describes[key] = describe
  end
end