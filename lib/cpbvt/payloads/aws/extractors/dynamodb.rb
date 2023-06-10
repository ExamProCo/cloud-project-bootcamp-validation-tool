module Cpbvt::Payloads::Aws::Extractors::Dynamodb
def self.included base; base.extend ClassMethods; end
module ClassMethods
# ------

def dynamodb_list_tables__table_name data, filters={}
  data['TableNames'].map do |table_name|
    {
      iter_id: table_name,
      table_name: table_name
    }
  end
end

# ------
end; end