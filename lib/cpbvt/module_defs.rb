# Define all our modules so we don't have nest modules
# names in our files
module Cpbvt
  module Validations; end
  module Tester; end
  module Payloads
    module Aws
      module Commands; end
      module Extractors; end
      module Policies; end
    end
  end
end