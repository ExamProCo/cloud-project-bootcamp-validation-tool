module Cpbvt::Payloads::Aws::Extractors::CognitoIdp
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def cognito_idp_list_user_pools__user_pool_id data, filters={}
  data['UserPools'].map do |t|
    {
      iter_id: t['Id'],
      user_pool_id: t['Id']
    }
  end
end

# ------
end; end