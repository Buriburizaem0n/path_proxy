# 在 middleware 冻结前插入，避免 FrozenError :contentReference[oaicite:1]{index=1}
if SiteSetting.path_proxy_enabled
  require_relative "../../lib/path_proxy/middleware"

  Rails.configuration.middleware.insert_before(
    Rack::Head,
    PathProxy::Middleware,
    source_prefix: SiteSetting.path_proxy_source_prefix,
    target_base:   SiteSetting.path_proxy_target_base
  )
end
