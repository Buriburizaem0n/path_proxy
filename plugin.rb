# frozen_string_literal: true

# name: path_proxy
# about: Proxy /path/* to an internal service
# version: 0.1
# authors: You

gem 'rack-proxy', '0.7.7', require: 'rack/proxy'

enabled_site_setting :path_proxy_enabled

after_initialize do
  require_relative "lib/path_proxy/middleware"
end
