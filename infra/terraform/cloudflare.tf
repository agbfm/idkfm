resource "cloudflare_pages_project" "idkfm" {
  account_id        = var.cloudflare_account_id
  name              = "idkfm"
  production_branch = "main"

  source {
    type = "github"
    config {
      owner                         = "agbfm"
      repo_name                     = "idkfm"
      production_branch             = "main"
      pr_comments_enabled           = false
      deployments_enabled           = true
      production_deployment_enabled = true
      preview_deployment_setting    = "custom"
      preview_branch_includes       = ["dev"]
      preview_branch_excludes       = ["main"]
    }
  }

  build_config {
    root_dir        = "web"
    destination_dir = "dist"
    build_command   = "bun run build"
  }
}

resource "cloudflare_record" "idkfm" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  type    = "CNAME"
  value   = cloudflare_pages_project.idkfm.subdomain
  proxied = true
}

resource "cloudflare_pages_domain" "my-domain" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.idkfm.name
  domain       = cloudflare_record.idkfm.hostname
}

resource "cloudflare_notification_policy_webhooks" "idkfm_webhooks" {
  account_id = var.cloudflare_account_id
  name       = "Discord webhook"
  url        = discord_webhook.webhook.url
}

resource "cloudflare_notification_policy" "idkfm_notifications" {
  account_id  = var.cloudflare_account_id
  name        = "Policy for Pages notification events"
  description = "Notification policy to alert when Pages deployments are made"
  enabled     = true
  alert_type  = "pages_event_alert"

  webhooks_integration {
    id = cloudflare_notification_policy_webhooks.idkfm_webhooks.id
  }
}
