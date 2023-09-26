Cpbvt::Tester::Runner.describe :week1 do
  spec :should_have_bucket_matching_name do |t|
    name = t.specific_params.s3_bucket_name
    assert_load('s3api-list-buckets','Buckets').find('Name',name) 
    set_pass_message "Found a bucket matching name: #{name}"
    set_fail_message "Failed to find a bucket with matching name: #{name}"
  end

  spec :should_have_bucket_static_website_hosting_index do |t|
    name = t.specific_params.s3_bucket_name
    bucket = assert_load('s3api-list-buckets','Buckets').find('Name',name).returns(:all)

    assert_not_nil(bucket)

    hosting = assert_load("s3api-get-bucket-website__#{name}").returns(:all)

    assert_json(hosting,'IndexDocument','Suffix').expects_eq('index.html')

    set_pass_message "Found s3 static website hosting serviing index.html for #{name}"
    set_fail_message "Failed to find s3 static website hosting serviing index.html for #{name}"
  end

  spec :should_have_bucket_static_website_hosting_error do |t|
    name = t.specific_params.s3_bucket_name
    bucket = assert_load('s3api-list-buckets','Buckets').find('Name',name).returns(:all)

    assert_not_nil(bucket)

    hosting = assert_load("s3api-get-bucket-website__#{name}").returns(:all)

    assert_json(hosting,'ErrorDocument','Key').expects_eq('error.html')

    set_pass_message "Found s3 static website hosting serviing index.html for #{name}"
    set_fail_message "Failed to find s3 static website hosting serviing index.html for #{name}"
  end

  spec :should_have_a_cloudfront_distrubition_to_static_website do |t|
    name = t.specific_params.s3_bucket_name
    aws_region = t.general_params.region

    items = assert_load('cloudfront-list-distributions','DistributionList').returns('Items')

    distribution =
    assert_find(items) do |assert,distribution|
      aliases = distribution['Aliases']
      assert.expects_eq(aliases,'Quantity',0)

      origins = distribution['Origins']
      assert.expects_eq(origins,'Quantity',1)

      origin = origins['Items'].first
      assert.expects_eq(origin,'Id','MyS3Origin')
    end.returns(:all)

    assert_not_nil(distribution)

    assert_json(distribution,'Status').expects_eq('Deployed')

    item = assert_json(distribution,'Origins','Items').returns(:first) 
    assert_json(item,'DomainName').expects_eq("#{name}.s3.#{aws_region}.amazonaws.com")

    origin_access_control_id = assert_json(item,'OriginAccessControlId').returns(:all)
    dist_id = assert_json(distribution,'Id').returns(:all)
    dist_domain_name = assert_json(distribution,'DomainName').returns(:all)

    set_state_value :static_website_distribution_id, dist_id
    set_state_value :static_website_distribution_domain_name, dist_domain_name
    set_state_value :origin_access_control_id, origin_access_control_id

    set_pass_message "Found static website CloudFront distrubution with origin to S3 static website bucket for: #{name}.s3.#{aws_region}.amazonaws.com"
    set_fail_message "Failed to find static website CloudFront with origin to S3 static website bucket for: #{name}.s3.#{aws_region}.amazonaws.com"
  end

  spec :should_have_ran_invalidation_on_distrubition do |t|
    dist_id = t.dynamic_params.static_website_distribution_id
    items = assert_load("cloudfront-list-invalidations__#{dist_id}","InvalidationList").returns('Items')

    found =
    assert_find(items) do |assert, item|
      assert.expects_eq(item,'Status','Completed')
    end.returns(:all)

    assert_not_nil found

    set_pass_message "Found static website CloudFront distrubution to have ran invalidations"
    set_fail_message "Failed to find static website CloudFront distrubution to have ran invalidations"
  end

  spec :should_have_access_origin_policy do |t|
    name = t.specific_params.s3_bucket_name
    control_id = t.dynamic_params.origin_access_control_id
    control_list = assert_load('cloudfront-list-origin-access-controls','OriginAccessControlList').returns(:all)

    assert_json(control_list,'Quantity').expects_gt(0)

    control_item =
    assert_find(control_list['Items']) do |assert, item|
      assert.expects_end_with(name)
    end.returns(:all)

    assert_json(control_item,'SigningProtocol').expects_eq('sigv4')
    assert_json(control_item,'SigningBehavior').expects_eq('always')
    assert_json(control_item,'OriginAccessControlOriginType').expects_eq('s3')
  end

  spec :check_index_file_content_type do |t|
    object = assert_load("s3api-get-head-object__index.html").returns(:all)

    assert_json(object,'ContentType').expects_eq('text/html')
    assert_json(object,'ContentLength').expects_gt(0)
  end

  #should be configured for website

  # cloudfront origin access control policy

  # cloudfront distrubution

  # invalidate cache
end
