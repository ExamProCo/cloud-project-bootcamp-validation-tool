Cpbvt::Tester::Runner.describe :networking do |t|
  spec :should_have_custom_vpc do |t|
    vpcs = assert_load('ec2_describe_vpcs','Vpcs').returns(:all)
  end
end