module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  availability_zone_public  = ["eu-north-1a", "eu-north-1b"]
  availability_zone_private = ["eu-north-1a", "eu-north-1b"]
  db_password          = var.db_password
}

module "alb" {
  source              = "./modules/alb"
  subnets             = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  security_group_id   = module.vpc.web_sg_id
  listener_arn = module.alb.alb_listener_arn

}

module "ecs" {
  source                      = "./modules/ecs"
  container_image             = var.container_image
  private_subnets = module.vpc.private_subnet_ids  
  public_subnets  = module.vpc.public_subnet_ids   
  security_group_id           = module.vpc.web_sg_id
  frontend_target_group_arn   = module.alb.target_group_arn
  db_host                     = module.rds.db_endpoint
  vpc_id                      = module.vpc.vpc_id

}


module "rds" {
  source             = "./modules/rds"
  subnet_ids = module.vpc.private_subnet_ids  # Liste complète
  security_group_id  = module.vpc.db_sg_id
  db_username        = var.db_username
  db_password        = var.db_password
}
