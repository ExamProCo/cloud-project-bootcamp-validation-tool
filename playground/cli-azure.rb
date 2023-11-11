# This is a wip script to explore how to work with the Azure CLI
require 'fileutils'
require 'ostruct'
require 'time'
require 'open3'


# These env vars are obtained by registering an application 
# with Azure Active Directory (Azure AD) know known as Microsoft Entra ID

# Entra ID > Enterprise Applications > All Applications
# https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/RegisteredApps

# We need to authenicate by creating a service principle
# https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash

# After creating a service principal in the Azure Active Directory you need to give this new user some roles within a subscription:
# 
# go to your subscription
# go to Access Control (IAM)
# Add a roles assignment (for instance make your service principal contributor)

# RePreq
# - In a subscription, you must have User Access Administrator or Role Based Access Control Administrator permissions, or higher, to create a service principal.
# - Create it via Azure Cloud Shell

# This command will create the env vars required
# az ad sp create-for-rbac 

# az storage account list

env_vars = {
  "AZURE_CLIENT_ID" => ENV["AZURE_CLIENT_ID"],
  "AZURE_TENANT_ID" => ENV["AZURE_TENANT_ID"],
  "AZURE_CLIENT_SECRET" => ENV["AZURE_CLIENT_SECRET"]
}
account_name = 'azvalcheckexp'
container_name = 'mycontainer'
blob_name = 'hello.txt'

login = <<COMMAND
az login --service-principal \
         --username #{ENV['AZURE_CLIENT_ID']} \
         --password #{ENV['AZURE_CLIENT_SECRET']} \
         --tenant #{ENV['AZURE_TENANT_ID']}
COMMAND
# This is what this command with return
#[
#  {
#    "cloudName": "AzureCloud",
#    "homeTenantId": "f73244ae-3e7....",
#    "id": "7f3352cf-6....",
#    "isDefault": true,
#    "managedByTenants": [],
#    "name": "Azure subscription",
#    "state": "Enabled",
#    "tenantId": "f73244ae-3e743....",

#    "user": {
#      "name": "19dc2af0-a12c....",
#      "type": "servicePrincipal"
#    }
#  }
#]


# Check for an storage account in a list
command_account = <<~COMMAND
az storage account list
COMMAND

# Check for a container with an azure storage account
command_container = <<~COMMAND
az storage container list \
--account-name #{account_name}
COMMAND

# Check for a blob object within a container
command_blob = <<~COMMAND
az storage blob exists  \
--account-name #{account_name} \
--container-name #{container_name} \
--name #{blob_name}
COMMAND

stdout_str, stderr_str, status = Open3.capture3(env_vars, command_account)
puts "\n Account ========"
puts "stdout str"
puts stdout_str
puts "stderr str"
puts stderr_str
puts "status"
puts status

stdout_str, stderr_str, status = Open3.capture3(env_vars, command_container)
puts "\n Container ========"
puts "stdout str"
puts stdout_str
puts "stderr str"
puts stderr_str
puts "status"
puts status

stdout_str, stderr_str, status = Open3.capture3(env_vars, command_blob)
puts "\n Blob ========"
puts "stdout str"
puts stdout_str
puts "stderr str"
puts stderr_str
puts "status"
puts status