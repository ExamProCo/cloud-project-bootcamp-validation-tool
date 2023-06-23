class Cpbvt::Tester::AssertLoad
  def initialize(manifest:, manifest_payload_key:)
    begin
      manifest.get_output(manifest_payload_key)
      #report.add :spec_key,
    rescue => e

    end
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
