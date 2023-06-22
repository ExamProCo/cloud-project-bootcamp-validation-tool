class Cpbvt::Tester::AssertLoad
  def initialize(manifest_payload_key:)
    manifest.get_output(manifest_payload_key)
  end

  def find
    # returns
  end

  def returns value
    if value == :all
    else
    end
  end
end
