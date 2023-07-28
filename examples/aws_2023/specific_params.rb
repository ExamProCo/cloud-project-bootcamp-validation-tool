require 'active_model'
class Aws2023::SpecificParams
  include ActiveModel::Validations
  attr_accessor :naked_domain_name,
                :github_full_repo_name,
                :cluster_name,
                :backend_family,
                :ecr_repo_name,
                :ecs_service_name,
                :cognito_user_pool_name,
                :apigateway_api_id,
                :raw_assets_bucket_name,
                :cfn_stack_name_machineuser,
                :cfn_stack_name_backend,
                :cfn_stack_name_sync,
                :cfn_stack_name_frontend,
                :cfn_stack_name_cicd,
                :cfn_stack_name_db,
                :cfn_stack_name_ddb,
                :cfn_stack_name_cluster,
                :cfn_stack_name_networking,
                :cfn_stack_name_cdk


  validates :naked_domain_name, presence: true#, format: { with: /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix }
  validates :github_full_repo_name, presence: true
  validates :cluster_name, presence: true
  validates :backend_family, presence: true
  validates :ecr_repo_name, presence: true
  validates :ecs_service_name, presence: true
  validates :cognito_user_pool_name, presence: true
  validates :apigateway_api_id, presence: true
  validates :raw_assets_bucket_name, presence: true
  validates :cfn_stack_name_machineuser, presence: true
  validates :cfn_stack_name_backend, presence: true
  validates :cfn_stack_name_sync, presence: true
  validates :cfn_stack_name_frontend, presence: true
  validates :cfn_stack_name_cicd, presence: true
  validates :cfn_stack_name_db, presence: true
  validates :cfn_stack_name_ddb, presence: true
  validates :cfn_stack_name_cluster, presence: true
  validates :cfn_stack_name_networking, presence: true
  validates :cfn_stack_name_cdk, presence: true

  def initialize(
    naked_domain_name:,
    github_full_repo_name:,
    cluster_name:,
    backend_family:,
    ecr_repo_name:,
    ecs_service_name:,
    cognito_user_pool_name:,
    apigateway_api_id:,
    raw_assets_bucket_name:,
    cfn_stack_name_machineuser:,
    cfn_stack_name_backend:,
    cfn_stack_name_sync:,
    cfn_stack_name_frontend:,
    cfn_stack_name_cicd:,
    cfn_stack_name_db:,
    cfn_stack_name_ddb:,
    cfn_stack_name_cluster:,
    cfn_stack_name_networking:,
    cfn_stack_name_cdk:
    )

    @naked_domain_name = naked_domain_name
    @github_full_repo_name = github_full_repo_name
    @cluster_name = cluster_name
    @backend_family = backend_family
    @ecs_service_name = ecs_service_name
    @ecr_repo_name = ecr_repo_name
    @cognito_user_pool_name = cognito_user_pool_name
    @apigateway_api_id = apigateway_api_id
    @raw_assets_bucket_name = raw_assets_bucket_name
    @cfn_stack_name_machineuser = cfn_stack_name_machineuser
    @cfn_stack_name_backend = cfn_stack_name_backend
    @cfn_stack_name_sync = cfn_stack_name_sync
    @cfn_stack_name_frontend = cfn_stack_name_frontend
    @cfn_stack_name_cicd = cfn_stack_name_cicd
    @cfn_stack_name_db = cfn_stack_name_db
    @cfn_stack_name_ddb = cfn_stack_name_ddb
    @cfn_stack_name_cluster =  cfn_stack_name_cluster
    @cfn_stack_name_networking = cfn_stack_name_networking
    @cfn_stack_name_cdk = cfn_stack_name_cdk
  end
end