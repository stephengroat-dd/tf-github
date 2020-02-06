provider "github" {}

data "github_user" "stephengroat-dd" {
  username = "stephengroat-dd"
}

resource "github_team" "test-test" {
  name = "test-team"
}

resource "github_team_membership" "team-member" {
  team_id = "${github_team.test-test.id}"
  username = "${data.github_user.stephengroat-dd.username}"
}
