
class AssertLoad
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

class AssertJson

  def expects_gt number
  end
end

class Test
  def assert_load manifest_payload_key
    obj = AssertLoad.new(
      manifest_payload_key: manifest_payload_key
    )
    return obj
  end

  def assert_json data, *keys
  end

  def set_pass_message
  end

  def set_fail_message
  end
end