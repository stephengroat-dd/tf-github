variable teams {
  type = set(string)
  description = "List of already existing teams in the Github organizations"
}

# TODO test a reorder to make sure not removed and re-added
variable user_info {
  description = "Map of Github username (key) and list of teams (values) of teams to join"
}
