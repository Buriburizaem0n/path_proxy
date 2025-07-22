# frozen_string_literal: true
# name: path_proxy
# version: 0.1
# about: Proxy /path/* to an internal service
# authors: You

gem 'rack-proxy', '0.7.6', require: 'rack/proxy'

enabled_site_setting :path_proxy_enabled

require_relative "lib/path_proxy/middleware"

module ::PathProxy
  class Engine < ::Rails::Engine
    engine_name "path_proxy"
    isolate_namespace PathProxy

    # 这里在 Rails 初始化很早的阶段执行，middleware 还没被冻结
    config.before_initialize do |app|
      app.middleware.insert_before(
        0,
        ::PathProxy::Middleware,
        source_prefix: SiteSetting.path_proxy_source_prefix.chomp("/"),
        target_base:   SiteSetting.path_proxy_target_base
      )
    end
  end
end

# 这里不要再动 middleware，只要让 Discourse 加载文件即可
after_initialize do
  # nothing
end
