terraform {
  required_providers {
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
