terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    discord = {
      source  = "Lucky3028/discord"
      version = "~> 1.6.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  cloud {
    organization = "idkfm"

    workspaces {
      name = "idkfm"
    }
  }
}
