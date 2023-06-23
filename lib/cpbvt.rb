require_relative 'cpbvt/module_defs'
require_relative 'cpbvt/version'
require_relative 'cpbvt/uploader'
require_relative 'cpbvt/manifest'
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