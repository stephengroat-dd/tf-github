provider "github" {}

# Add github organization memebership for each user
resource "github_membership" "team-member" {
  for_each = var.user_info
  username = each.key
  role     = "admin"
}

# Get existing team info
data "github_team" "team" {
  for_each = var.teams
  slug     = each.value
}

# Add user to each team
resource "github_team_membership" "team-member" {
  for_each = local.users_list
  username = split(",", each.value)[0]
  team_id  = lookup(local.team_list, split(",", each.value)[1], "none")
  role     = "maintainer"
}

locals {
  # map of team to team ID
  team_list = { for teamname in var.teams : teamname => data.github_team.team[teamname].id }
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
