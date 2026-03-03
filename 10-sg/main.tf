module "sg"{
    source = "../../terraform_aws_sg"
    project = var.project
    environment = var.environment
    sg_name = "mongodb"
    vpc_id = local.vpc_id
}