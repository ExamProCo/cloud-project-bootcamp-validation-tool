# Define all our modules so we don't have nest modules
# names in our files
module Cpbvt
  module Validations; end
  module Tester; end
  module Payloads
    module Gcp
      module Commands; end
      module Extractors; end
    end
    module Azure
      module Commands; end
      module Extractors; end
    end
    module Terraform
      module Commands; end
      module Extractors; end
    end
    module Aws
      module Commands; end
      module Extractors; end
      module Policies; end
    end
  end
end