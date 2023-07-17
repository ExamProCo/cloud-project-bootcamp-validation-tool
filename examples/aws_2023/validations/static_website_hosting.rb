Cpbvt::Tester::Runner.describe :static_website_hosting do
  spec :should_unblock_public_access do |t|
    naked_domain_name = t.specific_params.naked_domain_name

    access = assert_load("s3api-get-public-access-block__#{naked_domain_name}",'PublicAccessBlockConfiguration').returns(:all)

    assert_json(access,'BlockPublicPolicy').expects_false
    assert_json(access,'RestrictPublicBuckets').expects_false

    set_pass_message "Found s3 static website for #{naked_domain_name} to allow bucket policies"
    set_fail_message "Failed to find ss3 static website for #{naked_domain_name} to allow bucket policies"
  end

  spec :should_have_bucket_policy do |t|
    naked_domain_name = specific_params.naked_domain_name

    policy_json = assert_load("s3api-get-bucket-policy__#{naked_domain_name}",'Policy').returns(:all)
    policy = JSON.parse(policy_json)

    statements = assert_json(policy,'Statement').returns(:all)

    get_object_allow = 
    assert_find(statements) do |assert,statement|
      assert.expects_eq(statement,'Effect','Allow')
      assert.expects_eq(statement,'Action','s3:GetObject')
      assert.expects_eq(statement,'Resource',"arn:aws:s3:::#{naked_domain_name}/*")
    end

    assert_not_nil(get_object_allow)

    set_pass_message "Found valid bucket policy for #{naked_domain_name}"
    set_fail_message "Failed to find valid bucket policy for #{naked_domain_name}"
  end

  spec :should_have_a_naked_domain_bucket_static_website_hosting do |t|
    naked_domain_name = t.specific_params.naked_domain_name
    bucket = assert_load('s3api-list-buckets','Buckets').find('Name',naked_domain_name).returns(:all)
    
    assert_not_nil(bucket)

    hosting = assert_load("s3api-get-bucket-website__#{naked_domain_name}").returns(:all)

    assert_json(hosting,'IndexDocument','Suffix').expects_eq('index.html')

    set_pass_message "Found s3 static website hosting serviing index.html for #{naked_domain_name}"
    set_fail_message "Failed to find s3 static website hosting serviing index.html for #{naked_domain_name}"
  end

  spec :should_have_a_www_bucket_with_redirect do |t|
    naked_domain_name = t.specific_params.naked_domain_name
    www_domain_name = "www.#{t.specific_params.naked_domain_name}"
    bucket = assert_load('s3api-list-buckets','Buckets').find('Name',naked_domain_name).returns(:all)
    www_bucket = assert_load('s3api-list-buckets','Buckets').find('Name',www_domain_name).returns(:all)

    assert_not_nil(bucket)
    assert_not_nil(www_bucket)

    hosting = assert_load("s3api-get-bucket-website__#{www_domain_name}").returns(:all)

    assert_json(hosting,'RedirectAllRequestsTo','HostName').expects_eq(naked_domain_name)

    set_pass_message "Found s3 static website hosting for #{www_domain_name} redirecting to #{naked_domain_name}"
    set_fail_message "Failed to find s3 static website hosting for #{www_domain_name} redirecting to #{naked_domain_name}"
  end

  spec :should_have_a_cloudfront_distrubition_to_static_website do |t|
    naked_domain_name = t.specific_params.naked_domain_name
    www_domain_name = "www.#{t.specific_params.naked_domain_name}"

    domains = [naked_domain_name,www_domain_name]

    items = assert_load('cloudfront-list-distributions','DistributionList').returns('Items')

    distribution =
    assert_find(items) do |assert,distribution|
      aliases = distribution['Aliases']
      assert.expects_eq(aliases,'Quantity',2)
      all_domains = aliases['Items'].all?{|t| domains.include?(t) }
      assert.expects_true(all_domains)
    end.returns(:all)

    assert_not_nil(distribution)

    assert_json(distribution,'Status').expects_eq('Deployed')
    assert_json(distribution,'Origins','Quantity').expects_eq(1)

    item = assert_json(distribution,'Origins','Items').returns(:first) 
    assert_json(item,'DomainName').expects_eq("#{naked_domain_name}.s3.amazonaws.com")

    dist_id = assert_json(distribution,'Id').returns(:all)
    dist_domain_name = assert_json(distribution,'DomainName').returns(:all)

    set_state_value :static_website_distribution_id, dist_id
    set_state_value :static_website_distribution_domain_name, dist_domain_name

    set_pass_message "Found static website CloudFront distrubution with origin to S3 static website bucket for: #{naked_domain_name}.s3.amazonaws.com"
    set_fail_message "Failed to find static website CloudFront with origin to S3 static website bucket for: #{naked_domain_name}.s3.amazonaws.com"
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

  spec :should_have_support_for_spa do |t|
    dist_id = t.dynamic_params.static_website_distribution_id

    items = assert_load("cloudfront-list-distributions","DistributionList").returns('Items')

    distribution = 
    assert_find(items) do |assert,item|
      assert.expects_eq(item,'Id',dist_id)
    end.returns(:all)

    assert_not_nil distribution

    err = assert_json(distribution,'CustomErrorResponses','Items').returns(:first)

    assert_json(err,'ErrorCode').expects_eq(403)
    assert_json(err,'ResponsePagePath').expects_eq("/index.html")
    assert_json(err,'ResponseCode').expects_eq("200")

    set_pass_message "Found static website CloudFront distrubution to support SPA through custom error page"
    set_fail_message "Failed to find static website CloudFront distrubution to support SPA through custom error page"
  end

  spec :should_have_route53_to_distribution do |t|
    naked_domain_name = t.specific_params.naked_domain_name
    www_domain_name = "www.#{t.specific_params.naked_domain_name}"
    dist_domain_name = t.dynamic_params.static_website_distribution_domain_name

    zone_arn = assert_load('route53-list-hosted-zones','HostedZones').find('Name',"#{naked_domain_name}.").returns('Id')

    zone_id = zone_arn.split("/").last

    record_sets = assert_load("route53-list-resource-record-sets__#{zone_id}").returns('ResourceRecordSets')

    naked_record =
    assert_find(record_sets) do |assert,record|
      assert.expects_eq(record,'Name',"#{naked_domain_name}.")
      assert.expects_eq(record,'Type',"A")
    end.returns(:all)

    www_record =
    assert_find(record_sets) do |assert,record|
      assert.expects_eq(record,'Name',"#{www_domain_name}.")
      assert.expects_eq(record,'Type',"A")
    end.returns(:all)

    assert_not_nil(naked_record)
    assert_not_nil(www_record)

    assert_json(naked_record,'AliasTarget','DNSName').expects_eq("#{dist_domain_name}.")
    assert_json(www_record,'AliasTarget','DNSName').expects_eq("#{dist_domain_name}.")

    set_pass_message "Found route53 naked domain and www pointing to the cloudfront distribution for static website"
    set_fail_message "Failed to find route53 naked domain and www pointing to the cloudfront distribution for static website"
  end
end