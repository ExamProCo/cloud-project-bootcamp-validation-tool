require 'pp'
class Cpbvt::Tester::Runner
  @@describes = {}
  @@loaded = false

  def self.run!(
    validations_path:, 
    load_order: [],
    manifest:, 
    general_params:, 
    specific_params:, 
    dynamic_params:
  )
    report = Cpbvt::Tester::Report.new
    # loads the validations files
    # and the registers the describes and their specs
    unless @loadded
      pattern_path_files = File.join(validations_path,"*.rb")
      path_files = Dir.glob(pattern_path_files)
      path_files.each do |path|
        require path
      end
    end

    # run the actual specs
    load_order ||= @@describe.keys
    load_order.each do |describe_key|
      describe_instance = @@describes[describe_key]
      if describe_instance.nil?
        raise "Failed to find the describe block based on the describe key: #{describe_key}: describe_keys: #{@@describes.keys.join(',')} load_order: #{load_order.join(',')}"
      end
      describe_instance.specs.each do |spec_key,spec_instance|
        begin
          spec_instance.evaluate! report, manifest, general_params, specific_params, dynamic_params
          spec_instance.passed!
        rescue Cpbvt::Tester::AssertFail => e
          spec_instance.failed!
          # just skip to the next one...
          next
        end
      end
    end
    return JSON.parse(report.to_json)
  end

  def self.describe key, &block
    describe = Cpbvt::Tester::Describe.new(
      key: key.to_sym,
      context: block
    )
    raise "describe key already in use: #{key}" if @@describes.key?(key)
    @@describes[key] = describe
  end
end
