# This is a wip script to explore how to work with GCP CLI.# This is a wip script to explore how to work with the Azure CLI
require 'fileutils'
require 'ostruct'
require 'time'
require 'open3'

# Instead of setting multiple environment variables for credentials, Google Cloud typically uses a single environment variable GOOGLE_APPLICATION_CREDENTIALS that points to a JSON file containing your service account key.

#Create a Service Account and Key:
# - Go to the Google Cloud Console.
# - Navigate to IAM & Admin → Service accounts.
# - Create a service account or select an existing one.
# - Generate a new private key for this service account (usually in JSON format).
# Set the GOOGLE_APPLICATION_CREDENTIALS Environment Variable:
# - After downloading the JSON key file, set the GOOGLE_APPLICATION_CREDENTIALS environment variable to the path of this file.

# export GOOGLE_APPLICATION_CREDENTIALS="/workspace/cloud-project-bootcamp-validation-tool/gcp-service-account-key.json"

# login
login = <<COMMAND
gcloud auth activate-service-account \
--key-file=#{ENV['GOOGLE_APPLICATION_CREDENTIALS']}
COMMAND


## Users can grant cross account role permission using
# gcloud projects add-iam-policy-binding <USERS PROJECT ID> --member serviceAccount:<VALIDATOR SERVICE ACCOUNT>@<PROJECT>.iam.gserviceaccount.com --role=roles/viewer

list_comamnd = <<COMMAND
gsutil ls \
-p #{ENV['GCP_PROJECT_ID']}
COMMAND

bucket = 'ship-bucket'
file = 'ships.csv'

# We don't list project for some reason here
# or it complains out file
# gsutil doesn't support json output so maybe we
# should not use this.
object_command = <<COMMAND
gsutil ls gs://#{bucket}/#{file} \
COMMAND

# We wil probably want to use gcloud because it outputs in json
list_buckets = <<COMMAND
gcloud storage buckets list --format=json --project $GCP_PROJECT_ID
COMMAND