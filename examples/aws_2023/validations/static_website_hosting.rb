class Aws2023::Validations::StaticWebsiteHosting

  def self.should_have_a_naked_domain_bucket_static_website_hosting(manifest:,specific_params:)
    naked_domain_name = specific_params.naked_domain_name
    data = manifest.get_output!('s3api-list-buckets')
    data['Buckets'].find{|t| t['Name'] == naked_domain_name}

    hosting = manifest.get_output!("s3api-get-bucket-website__#{naked_domain_name}")

    found =
    hosting['IndexDocument']['Suffix'] = 'index.html'

    if found
      {result: {score: 10, message: "Found s3 static website hosting serviing index.html for #{naked_domain_name}"}}
    else
      {result: {score: 0, message: "Failed to find s3 static website hosting serviing index.html for #{naked_domain_name}"}}
    end
  end

  def self.should_have_a_www_bucket_with_redirect(manifest:,specific_params:)
    naked_domain_name = specific_params.naked_domain_name
    www_domain_name = "www.#{specific_params.naked_domain_name}"
    data = manifest.get_output!('s3api-list-buckets')
    data['Buckets'].find{|t| t['Name'] == naked_domain_name}

    hosting = manifest.get_output!("s3api-get-bucket-website__#{www_domain_name}")

    found =
    hosting['RedirectAllRequestsTo']['HostName'] = naked_domain_name

    if found
      {result: {score: 10, message: "Found s3 static website hosting for #{www_domain_name} redirecting to #{naked_domain_name}"}}
    else
      {result: {score: 0, message: "Failed to find s3 static website hosting for #{www_domain_name} redirecting to #{naked_domain_name}"}}
    end
  end

  def self.should_have_a_cloudfront_distrubition_to_static_website(manifest:,specific_params:)
    naked_domain_name = specific_params.naked_domain_name
    www_domain_name = "www.#{specific_params.naked_domain_name}"

    domains = [naked_domain_name,www_domain_name]

    data = manifest.get_output!('cloudfront-list-distributions')

    distribution =
    data['DistributionList']['Items'].find do |distribution|
      distribution['Aliases']['Quantity'] == 2 &&
      distribution['Aliases']['Items'].all?{|t| domains.include?(t) }
    end

    found =
    distribution['Status'] == 'Deployed' &&
    distribution['Origins']['Quantity'] == 1 &&
    distribution['Origins']['Items'].first['DomainName'] == "#{naked_domain_name}.s3.amazonaws.com"

    dist_id = distribution['Id']
    dist_domain_name = distribution['DomainName']

    if found
      {
        result: {
          score: 10, 
          message: "Found static website CloudFront distrubution with origin to S3 static website bucket for: #{naked_domain_name}.s3.amazonaws.com"
        },
        static_website_distribution_id: dist_id,
        static_website_distribution_domain_name: dist_domain_name
      }
    else
      {result: {score: 0, message: "Failed to find static website CloudFront with origin to S3 static website bucket for: #{naked_domain_name}.s3.amazonaws.com"}}
    end
  end

  def self.should_have_ran_invalidation_on_distrubition(manifest:,specific_params:,static_website_distribution_id:)
    invalidations = manifest.get_output!("cloudfront-list-invalidations__#{static_website_distribution_id}")

    found =
    invalidations['InvalidationList']['Items'].any?{|t| t['Status'] == 'Completed' }

    if found
      {result: {score: 10, message: "Found static website CloudFront distrubution to have ran invalidations"}}
    else
      {result: {score: 0, message: "Failed to find static website CloudFront distrubution to have ran invalidations"}}
    end
  end

  def self.should_have_support_for_spa(manifest:,specific_params:,static_website_distribution_id:)
    data = manifest.get_output!('cloudfront-list-distributions')
    distribution = data['DistributionList']['Items'].find{|t| t['Id'] == static_website_distribution_id}

    err = distribution['CustomErrorResponses']['Items'].first

    # ensure that it serves up
    found =
    err['ErrorCode'] == 403 &&
    err['ResponsePagePath'] == "/index.html" &&
    err['ResponseCode'] == "200"

    if found
      {result: {score: 10, message: "Found static website CloudFront distrubution to support SPA through custom error page"}}
    else
      {result: {score: 0, message: "Failed to find static website CloudFront distrubution to support SPA through custom error page"}}
    end
  end

  def self.should_have_route53_to_distribution(manifest:,specific_params:,static_website_distribution_domain_name:)
    naked_domain_name = specific_params.naked_domain_name
    www_domain_name = "www.#{specific_params.naked_domain_name}"

    data = manifest.get_output!('route53-list-hosted-zones')

    zone =
    data['HostedZones'].find do |zone|
      zone['Name'] == "#{naked_domain_name}."
    end

    zone_id = zone['Id'].split("/").last

    zone_data = manifest.get_output!("route53-list-resource-record-sets__#{zone_id}")

    naked_record =
    zone_data['ResourceRecordSets'].find do |record|
      record['Name'] == "#{naked_domain_name}." &&
      record['Type'] == "A"
    end

    www_record =
    zone_data['ResourceRecordSets'].find do |record|
      record['Name'] == "#{www_domain_name}." &&
      record['Type'] == "A"
    end

    found =
    naked_record['AliasTarget']['DNSName'] == "#{static_website_distribution_domain_name}." &&
    www_record['AliasTarget']['DNSName'] == "#{static_website_distribution_domain_name}."

    if found
      {result: {score: 10, message: "Found route53 naked domain and www pointing to the cloudfront distribution for static website"}}
    else
      {result: {score: 0, message: "Failed to find route53 naked domain and www pointing to the cloudfront distribution for static websit"}}
    end
  end
end