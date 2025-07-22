require_relative "../../lib/path_proxy/middleware"

Rails.configuration.middleware.insert_before(
  0,
  PathProxy::Middleware,
  source_prefix: SiteSetting.path_proxy_source_prefix.chomp("/"),
  target_base:   SiteSetting.path_proxy_target_base
)
