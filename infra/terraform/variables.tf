variable "github_token" {
  description = "The access token for the GitHub API"
  sensitive   = true
  type        = string
}

variable "cloudflare_account_id" {
  description = "The Cloudflare account ID"
  type        = string
}

variable "cloudflare_api_token" {
  description = "The API token for Cloudflare, to use as a bearer token"
  sensitive   = true
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare zone ID"
  sensitive   = true
  type        = string
}

variable "discord_token" {
  description = "The Discord API token"
  sensitive   = true
  type        = string
}

variable "discord_server_id" {
  description = "The ID of the Discord server to manage"
  type        = string
}
