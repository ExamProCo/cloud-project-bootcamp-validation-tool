class Aws2023::Validations::StaticWebsiteHosting

  def self.should_have_a_naked_domain_bucket_static_website_hosting(manifest:,specific_params:)
    naked_domain_name = specific_params.domain_name
    buckets = manifest.get_output!('s3api-list-buckets')
    buckets{|t| t['Name'] == naked_domain_name}

    hosting = manifest.get_output!("s3api-get-bucket-website__#{naked_domain_name}")

    hosting['IndexDocument']['Suffix'] = 'index.html'
  end

  def self.should_have_a_www_bucket_with_redirect(manifest:,specific_params:)
    naked_domain_name = specific_params.domain_name
    wwww_domain_name = "www.#{specific_params.domain_name}"
    buckets = manifest.get_output!('s3api-list-buckets')
    buckets{|t| t['Name'] == www_domain_name}

    hosting = manifest.get_output!("s3api-get-bucket-website__#{www_domain_name}")

    hosting['RedirectAllRequestsTo']['HostName'] = naked_domain_name
  end

  def self.should_have_a_cloudfront_distrubition
  end

  def self.should_have_route53_to_distrubition
  end
end