$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cpbvt/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cloud_project_bootcamp_validation_tool"
  s.version     = Cpbvt::VERSION
  s.authors     = ["ExamPro"]
  s.email       = ["andrew@exampro.co"]
  s.homepage    = "https://www.exampro.co"
  s.summary     = 'Cloud Project Bootcamp Validation Tool'
  s.description = 'Cloud Project Bootcamp Validation Tool'
  s.license     = "MIT"

  s.add_dependency 'ruby-openai'
  s.add_dependency 'aws-sdk-s3'
  s.files = Dir["{app,config,db,lib}/**/*", "README.md"]
  s.test_files = Dir["spec/**/*"]
end