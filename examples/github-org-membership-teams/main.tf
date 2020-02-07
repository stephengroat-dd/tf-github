terraform {
  required_version = "~> 0.12.6"
}

provider "github" {
  version = ">= 2.3.1, < 3.0.0"
}

module "github_org" {
  source = "../.."

  teams = [
    "secdev",
    "xuxu"
  ]

  user_info = {
    "joshhuie"        = ["secdev", "xuxu"]
    "stephengroat-dd" = ["secdev"]
    "ivantopolcic"    = ["xuxu"]
  }
}
