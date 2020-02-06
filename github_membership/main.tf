provider "github" {}

resource "github_membership" "team-member" {
  for_each = var.usernames
  username = each.value
  role = "admin"
}
