provider "github" {}

variable teams {
  type = set(string)
  default = [
    "secdev",
    "xuxu"
  ]
}

# TODO test a reorder to make sure not removed and re-added
variable user_info {
  default = {
    "joshhuie" = [ "secdev", "xuxu" ]
    "stephengroat-dd" = ["secdev"]
    "ivantopolcic" = ["xuxu"]
  }
}

# TODO see if a data block can be used instead of a resource block to avoid team creation
resource "github_team" "team" {
  for_each = var.teams
  name = each.value
}

resource "github_team_membership" "team-member" {
  for_each = local.users_list
  username = split(",", each.value)[0]
  team_id  = lookup(local.team_list, split(",", each.value)[1], "none")
}

locals { 
  # map of team to team ID
  team_list = {for teamname in var.teams: teamname => github_team.team[teamname].id}
  # set of strings of users and any associated teams in CSV format, duplicating entries for users with multiple team membership
  users_list = toset(flatten([
    for user, teams in var.user_info : [
      for team in teams : [
        # from https://github.com/join, "Username may only contain alphanumeric characters or single hyphens, and cannot begin or end with a hyphen."
        # TODO Find restrictions on organization names
        join(",", [user, team])
      ]
    ]
  ]))
}
