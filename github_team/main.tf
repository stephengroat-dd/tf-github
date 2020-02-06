provider "github" {}

resource "github_team" "test-test" {
  name = "test-team"
}

resource "github_team_membership" "team-member" {
  for_each = var.usernames
  team_id = "${github_team.test-test.id}"
  username = each.value
}
