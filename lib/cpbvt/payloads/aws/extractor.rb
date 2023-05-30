class Cpbvt::Payloads::Aws::Extractor
  include Cpbvt::Payloads::Aws::Extractors::Acm
  include Cpbvt::Payloads::Aws::Extractors::Apigatewayv2
  include Cpbvt::Payloads::Aws::Extractors::Cloudformation
  include Cpbvt::Payloads::Aws::Extractors::Cloudfront
  include Cpbvt::Payloads::Aws::Extractors::Codepipeline
  include Cpbvt::Payloads::Aws::Extractors::CognitoIdp
  include Cpbvt::Payloads::Aws::Extractors::Dynamodb
  include Cpbvt::Payloads::Aws::Extractors::Ecr
  include Cpbvt::Payloads::Aws::Extractors::Ecs
  include Cpbvt::Payloads::Aws::Extractors::Elbv2
  include Cpbvt::Payloads::Aws::Extractors::Lambda
  include Cpbvt::Payloads::Aws::Extractors::Route53
  include Cpbvt::Payloads::Aws::Extractors::S3api
end