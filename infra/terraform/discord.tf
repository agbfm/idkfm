data "discord_server" "idkfm" {
  server_id = var.discord_server_id
}

data "discord_role" "everyone" {
  server_id = data.discord_server.idkfm.id
  name      = "@everyone"
}

data "discord_permission" "deny_view_channel" {
  view_channel = "deny"
}

resource "discord_category_channel" "idkfm" {
  name      = "idkfm"
  server_id = data.discord_server.idkfm.id
  position  = 0
}

resource "discord_text_channel" "alerts_idkfm" {
  name      = "alerts-idkfm"
  server_id = data.discord_server.idkfm.id
  category  = discord_category_channel.idkfm.id
  position  = 0
}

resource "discord_channel_permission" "alerts_idk_private" {
  channel_id   = discord_text_channel.alerts_idkfm.id
  type         = "role"
  overwrite_id = data.discord_role.everyone.id
  deny         = data.discord_permission.deny_view_channel.deny_bits
}

resource "discord_webhook" "webhook" {
  channel_id = discord_text_channel.alerts_idkfm.id
  name       = "Cloudflare alerts"
}
