# frozen_string_literal: true

# name: path_proxy
# about: Proxy /path/* to an internal service
# version: 0.1
# authors: You

gem 'rack-proxy', '0.7.6', require: 'rack/proxy'

enabled_site_setting :path_proxy_enabled

after_initialize do
  require_relative "lib/path_proxy/middleware"
end

register_middleware do |middleware|
  next unless SiteSetting.path_proxy_enabled

  middleware.insert_before(
    Rack::Head,
    PathProxy::Middleware,
    source_prefix: SiteSetting.path_proxy_source_prefix,
    target_base:   SiteSetting.path_proxy_target_base
  )
end
