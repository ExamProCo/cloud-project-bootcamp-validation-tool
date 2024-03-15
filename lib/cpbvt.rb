require_relative 'cpbvt/module_defs'
require_relative 'cpbvt/version'
require_relative 'cpbvt/uploader'
require_relative 'cpbvt/downloader'
require_relative 'cpbvt/manifest'

# --- require cpbvt/payloads/azure/commands/*
az_commands_path = File.join(File.dirname(__FILE__),'cpbvt','payloads','azure','commands','*.rb')
Dir.glob(az_commands_path,&method(:require))
# ---
require_relative 'cpbvt/payloads/azure/general_params'
require_relative 'cpbvt/payloads/azure/runner'
require_relative 'cpbvt/payloads/azure/command'
require_relative 'cpbvt/payloads/azure/policy'

# --- require cpbvt/payloads/gcp/commands/*
gcp_commands_path = File.join(File.dirname(__FILE__),'cpbvt','payloads','gcp','commands','*.rb')
Dir.glob(gcp_commands_path,&method(:require))
# ---
require_relative 'cpbvt/payloads/gcp/general_params'
require_relative 'cpbvt/payloads/gcp/runner'
require_relative 'cpbvt/payloads/gcp/command'

# --- require cpbvt/payloads/terraform/commands/*
tf_commands_path = File.join(File.dirname(__FILE__),'cpbvt','payloads','terraform','commands','*.rb')
Dir.glob(tf_commands_path,&method(:require))
# ---
require_relative 'cpbvt/payloads/terraform/general_params'
require_relative 'cpbvt/payloads/terraform/runner'
require_relative 'cpbvt/payloads/terraform/command'
require_relative 'cpbvt/payloads/terraform/policy'

# --- require cpbvt/payloads/aws/extractors/*
aws_commands_path = File.join(File.dirname(__FILE__),'cpbvt','payloads','aws','extractors','*.rb')
Dir.glob(aws_commands_path,&method(:require))
# ---
require_relative 'cpbvt/payloads/aws/general_params'
require_relative 'cpbvt/payloads/aws/extractor'
# --- require cpbvt/payloads/aws/commands/*
aws_commands_path = File.join(File.dirname(__FILE__),'cpbvt','payloads','aws','commands','*.rb')
Dir.glob(aws_commands_path,&method(:require))
# ---
require_relative 'cpbvt/payloads/aws/runner'
require_relative 'cpbvt/payloads/aws/command'
# --- require cpbvt/payloads/aws/policies/*
aws_commands_path = File.join(File.dirname(__FILE__),'cpbvt','payloads','aws','policies','*.rb')
Dir.glob(aws_commands_path,&method(:require))
# ---
require_relative 'cpbvt/payloads/aws/policy'

require_relative 'cpbvt/tester/report'
require_relative 'cpbvt/tester/runner'
require_relative 'cpbvt/tester/describe'
require_relative 'cpbvt/tester/spec'
require_relative 'cpbvt/tester/assert_load'
require_relative 'cpbvt/tester/assert_json'
require_relative 'cpbvt/tester/assert_cfn_resource'
require_relative 'cpbvt/tester/assert_find'
require_relative 'cpbvt/tester/assert_select'
