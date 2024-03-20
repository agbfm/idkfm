locals {
  project_name = "idkfm"
}

resource "cloudflare_pages_project" "idkfm" {
  account_id        = var.cloudflare_account_id
  name              = local.project_name
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

resource "cloudflare_record" "idkfm_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  value   = cloudflare_record.idkfm.hostname
  proxied = true
}

resource "cloudflare_ruleset" "www_redirect" {
  zone_id     = var.cloudflare_zone_id
  name        = "idkfm-www-redirect"
  description = "Redirects ruleset"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules {
    action = "redirect"
    action_parameters {
      from_value {
        status_code = 301
        target_url {
          value = "https://idk.fm"
        }
        preserve_query_string = true
      }
    }
    expression  = "(http.host eq \"www.idk.fm\")"
    description = "Redirect www.idk.fm to idk.fm"
    enabled     = true
  }
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

// manually call the cloudflare projects api to get the project id (to get around known bug)
// https://github.com/cloudflare/terraform-provider-cloudflare/issues/1998
data "http" "cloudflare_project_api_idkfm" {
  url = "https://api.cloudflare.com/client/v4/accounts/${var.cloudflare_account_id}/pages/projects/${local.project_name}"

  request_headers = {
    Authorization = "Bearer ${var.cloudflare_api_token}"
  }

  lifecycle {
    postcondition {
      condition     = contains([200], self.status_code)
      error_message = "Failed to get Cloudflare project details via http request to Cloudflare API"
    }
  }
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

  filters {
    environment = ["ENVIRONMENT_PRODUCTION"]
    event       = ["EVENT_DEPLOYMENT_FAILED", "EVENT_DEPLOYMENT_SUCCESS"]
    project_id  = [jsondecode(data.http.cloudflare_project_api_idkfm.response_body).result.id]
  }
}
