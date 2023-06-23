class Aws2023::DynamicParams
  attr_accessor :vpc_id,
                :public_subnet_id_1,
                :public_subnet_id_2,
                :public_subnet_id_3,
                :igw_id,
                :pipeline_name,
                :backend_tg_arn,
                :alb_sg_id,
                :serv_sg_id,
                :static_website_distribution_id,
                :static_website_distribution_domain_name,
                :assets_distribution_id,
                :assets_distribution_domain_name
end