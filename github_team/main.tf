provider "github" {}

variable teams {
  type = set(string)
  default = [
    "secdev",
    "xuxu"
  ]
}

resource "github_team" "team" {
  for_each = var.teams
  name = each.value
}

resource "github_team_membership" "team-member" {
  for_each = local.users_list
  username = split(",", each.value)[0]
  team_id  = lookup(local.team_list, split(",", each.value)[1], "none")
}

variable user_info {
  default = {
    "joshhuie" = [ "secdev", "xuxu" ]
    "stephengroat-dd" = ["secdev"]
    "ivantopolcic" = ["xuxu"]
  }
}

locals { 
  team_list = {for teamname in var.teams: teamname => github_team.team[teamname].id}
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
