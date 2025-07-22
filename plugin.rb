# frozen_string_literal: true
# name: path_proxy
# about: Proxy /path/* to an internal service
# version: 0.1
# authors: You

gem 'rack-proxy', '0.7.6', require: 'rack/proxy'  # 官方推荐在 plugin.rb 声明 gem。:contentReference[oaicite:1]{index=1}

require_relative "lib/path_proxy/middleware"

module ::PathProxy
  class Engine < ::Rails::Engine
    engine_name "path_proxy"
    isolate_namespace PathProxy

    # 不要在这里用 SiteSetting
    config.before_initialize do |app|
      app.middleware.insert_before(
        0,
        ::PathProxy::Middleware
      )
    end
  end
end

# 这里不再动 middleware
after_initialize do
  # nothing
end
