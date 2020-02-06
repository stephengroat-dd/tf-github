#module "terraform_team" {
#  source = "./github_team"
#  usernames  = ["stephengroat-dd", "joshhuie"]
#}

module "terraform_membership" {
  source = "./github_membership"
#  usernames  = ["stephengroat-dd", "joshhuie"]
}
