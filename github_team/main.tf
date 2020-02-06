provider "github" {}

variable teams {
  type = set(string)
  default = [
    "team-1",
    "team-2"
  ]
}

resource "github_team" "team" {
  for_each = var.teams
  name = each.value
}

resource "github_team_membership" "team-member" {
  for_each = local.users_list
  username = split(",", each.value)[0]
  team_id  = local.team_list[split(",", each.value)[1]].id
}

variable user_info {
  default = {
    "secdev" = [ "joshhuie", "stephengroat-dd" ]
  }
}

locals { 
  team_list = for team in var.teams : { 
    team = github_team.team["team-1"].id
  }
  users_list = toset(flatten([
    for user, teams in var.user_info : [
      for team in teams : [
        join(",", [user, team])
      ]
    ]
  ]))
}

output users_list {
  value = local.users_list
}

output teams_list {
  value = local.team_list
}
