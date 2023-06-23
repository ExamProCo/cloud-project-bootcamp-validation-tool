class AssertJson
  def expects_eq value
    data == value
  end

  def expects_gt number
    data > number
  end

  def expects_match value
    data.match(value)
  end
end