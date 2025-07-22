# frozen_string_literal: true

# name: path-proxy
# about: Proxy /path/* to an internal service
# version: 0.1
# authors: You
# url: https://www.example.com

enabled_site_setting :path_proxy_enabled

after_initialize do
  require_relative "lib/path_proxy/middleware"

  if SiteSetting.path_proxy_enabled
    # 在 Rails middleware 中插入
    Discourse::Application.config.middleware.insert_before(
      Rack::Head,
      PathProxy::Middleware,
      source_prefix: SiteSetting.path_proxy_source_prefix, # 例如 /path
      target_base:   SiteSetting.path_proxy_target_base    # 例如 http://127.0.0.1:8551
    )
  end
end
