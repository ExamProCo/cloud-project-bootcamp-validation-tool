class Aws2023::Validator
  def self.run(
      project_scope:,
      run_uuid:,
      user_uuid:,
      manifest_file:,
      payloads_bucket:
  )

  manifest = Cpbvt::Manifest.load_from_file manifest_file
  manifest.pull!

  # Networking Validation
    # should have a custom vpc 
    # with 3 public subnets
    # with a IGW
    # with a route table that routes to the internet

  # CI/CD Validation
    # should have a codepipeline
    # with a source from github to the expected bootcamp repo
    # with a build step to codebuild
    # with deployment using ECS deployer

  # IaC Validation
    # should have CFN stacks named the following: <stack_names>

  # Primary Compute Validation
    # Should have an ECS cluster named <cluster_name>
      # with fargate service running named <service_name> on port 4567
        # and the service should have a security group <sg-serv-id>
          # and it should provide access to the  alb securitygroup <sg-alb-id> on port 4567

    # should have a cloud map namespace named <cloudmap_namespace>
  
  # Frontend Static Website Hosting Validation
    # should have an s3 bucket called <s3-website-bucket-name>
      # with cors?
      # with block public access turnred off?
      # with a bucket policy?
    # should have a CFN distribution

  # Primary Db Validation
    # should have an RDS instance running
    # the RDS instance should be publically avaliable
    # the RDS instance should have a security group <sg-rds-id>
    # and it should provide access to the fargate service security group <sg-serv-id> on port 5432

  # DynamoDB Validation
    # should have a dynamodb table named <db-table-name>
      # should have a dynamodbstream

  # Serverless Asset Pipeline Validation
    # should have an HTTP API Gateway
      # with an /avatar endpoint
        # with lambda authorizer
      # with a proxy endpoint
        # with lambda authorizer

  # Authenication Validation
    # should have a Cognito User Pool
      # with a trigger on post configuration

  # Domain Management?

  # Container Repo Storage?

  end # def self.run
end # class