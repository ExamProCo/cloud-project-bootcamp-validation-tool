module Cpbvt::Payloads::Aws::Extractors::Apigatewayv2
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def apigatewayv2_get_apis___app_id(data)
  data['Items'].map do |x| 
    {
      iter_id: x['ApiId'],
      api_id: x['ApiId']
    } 
  end
end

# ------
end; end