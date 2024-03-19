resource "github_repository" "repo" {
  name         = "idkfm"
  description  = "Monorepo for my portfolio website."
  visibility   = "public"
  homepage_url = "https://idk.fm"

  has_downloads = false
  has_issues    = false
  has_projects  = false
  has_wiki      = false
}
