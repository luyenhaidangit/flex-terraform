########################################
# Github OIDC
########################################

module "github_oidc" {
  source = "../../modules/oidc/github"

  name = "dev-flex"
}