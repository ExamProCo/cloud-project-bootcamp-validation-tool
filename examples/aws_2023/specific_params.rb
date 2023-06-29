require 'active_model'
class Aws2023::SpecificParams::Puller
  include ActiveModel::Validations

  attr_accessor :naked_domain_name,
                :cluster_name,
                :backend_family,
                :raw_assets_bucket_name

  #formatting failed with drummer-test-app.online
  validates :naked_domain_name, presence: true#, format: { with: /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix }
  validates :cluster_name, presence: true
  validates :backend_family, presence: true
  validates :raw_assets_bucket_name, presence: true

  def initialize(
    naked_domain_name:,
    cluster_name:,
    backend_family:,
    raw_assets_bucket_name:
  )
    @naked_domain_name = naked_domain_name
    @cluster_name = cluster_name
    @backend_family = backend_family
    @raw_assets_bucket_name = raw_assets_bucket_name
  end
end


class Aws2023::SpecificParams::Validator
  include ActiveModel::Validations
  attr_accessor :naked_domain_name,
                :github_full_repo_name,
                :cluster_name,
                :backend_family,
                :cognito_user_pool_name,
                :apigateway_api_id,
                :raw_assets_bucket_name

  validates :naked_domain_name, presence: true#, format: { with: /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix }
  validates :github_full_repo_name, presence: true
  validates :cluster_name, presence: true
  validates :backend_family, presence: true
  validates :cognito_user_pool_name, presence: true
  validates :apigateway_api_id, presence: true
  validates :raw_assets_bucket_name, presence: true

  def initialize(
    naked_domain_name:,
    github_full_repo_name:,
    cluster_name:,
    backend_family:,
    cognito_user_pool_name:,
    apigateway_api_id:,
    raw_assets_bucket_name:
    )

    @naked_domain_name = naked_domain_name
    @github_full_repo_name = github_full_repo_name
    @cluster_name = cluster_name
    @backend_family = backend_family
    @cognito_user_pool_name = cognito_user_pool_name
    @apigateway_api_id = apigateway_api_id
    @raw_assets_bucket_name = raw_assets_bucket_name
  end
end