data "discord_server" "idkfm" {
  server_id = var.discord_server_id
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

resource "discord_webhook" "webhook" {
  channel_id = discord_text_channel.alerts_idkfm.id
  name       = "Cloudflare alerts"
}
