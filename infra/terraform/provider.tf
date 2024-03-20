provider "github" {
  token = var.github_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "discord" {
  token = var.discord_token
}
