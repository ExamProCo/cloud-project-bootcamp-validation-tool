module Cpbvt::Payloads::Aws::Extractors::Lambda
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def lambda_list_functions__function_name data
  data['Functions'].map do |t|
    name = t['FunctionName']
    {
      iter_id: name,
      function_name: name
    }
  end
end

# ------
end; end