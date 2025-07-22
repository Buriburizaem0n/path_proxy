# frozen_string_literal: true
# name: path_proxy
# about: Proxy /path/* to an internal service
# version: 0.1
# authors: You

gem 'rack-proxy', '0.7.6', require: 'rack/proxy'

require_relative "lib/path_proxy/middleware"

module ::PathProxy
  class Engine < ::Rails::Engine
    engine_name "path_proxy"
    isolate_namespace PathProxy

    # 这里只挂中间件，不访问 SiteSetting
    config.before_initialize do |app|
      app.middleware.insert_before(0, ::PathProxy::Middleware)
    end
  end
end

after_initialize do
  # nothing
end
