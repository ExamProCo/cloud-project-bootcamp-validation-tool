Cpbvt::Tester::Runner.describe :example do
  spec :should_have_bucket do |t|
    bucket_name = t.specific_params.gcp_bucket_name
    bucket = assert_load("gcloud-storage-buckets-list").find("name",bucket_name).returns(:all)

    assert_not_nil(bucket)
    set_pass_message "Found Google Cloud Storage Bucket named #{bucket_name}"
    set_fail_message "Failed to find Google Cloud Storage Bucket named #{bucket_name}"
  end
  
  spec :should_have_bucket_object do |t|
    bucket_name = t.specific_params.gcp_bucket_name
    object_name = "ships.csv"

    object = assert_load("gcloud-storage-objects-describe__#{bucket_name}").returns(:all)

    assert_eq(object,'content_type','text/csv')
    set_pass_message "Found Google Cloud Storage Bucket Object named #{object_name}"
    set_fail_message "Failed to find Google Cloud Storage Bucket Object named #{object_name}"
  end
end