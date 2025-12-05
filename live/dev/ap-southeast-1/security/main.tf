module "sg" {
  source = "../../../../modules/security"

  name   = "flex"
  vpc_id = module.vpc.vpc_id

  alb_ingress_cidrs = ["0.0.0.0/0"]

  app_ingress_sg_ids = [
    module.sg.alb_sg_id
  ]

  db_ingress_sg_ids = [
    module.sg.app_sg_id
  ]
}
