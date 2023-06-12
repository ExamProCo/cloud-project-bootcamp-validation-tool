require 'active_model'
class Aws2023::SpecificParams::Puller
  include ActiveModel::Validations

  attr_accessor :naked_domain_name

  validates :naked_domain_name, presence: true, format: { with: /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix }

  def initialize(naked_domain_name:)
    @naked_domain_name = naked_domain_name
  end
end


class Aws2023::SpecificParams::Validator
  include ActiveModel::Validations
  attr_accessor :naked_domain_name,
                :github_full_repo_name

  validates :naked_domain_name, presence: true, format: { with: /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix }
  validates :github_full_repo_name, presence: true

  def initialize(
    naked_domain_name:,
    github_full_repo_name:
    )

    @naked_domain_name = naked_domain_name
    @github_full_repo_name = github_full_repo_name
  end
end