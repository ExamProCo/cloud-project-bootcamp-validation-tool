Cpbvt::Tester::Runner.describe :s3 do
  spec :should_have_bucket_matching_name do |t|
    name = t.specific_params.s3_bucket_name
    assert_load('s3api-list-buckets','Buckets').find('Name',name) 
    set_pass_message "Found a bucket matching name: #{name}"
    set_fail_message "Failed to find a bucket with matching name: #{name}"
  end
end
