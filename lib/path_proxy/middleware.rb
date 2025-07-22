require "rack/proxy"
require "uri"

module PathProxy
  class Middleware < Rack::Proxy
    def initialize(app, _opts = {})
      super(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)

      # 在这里再访问 SiteSetting，保证它已加载
      source_prefix = SiteSetting.path_proxy_source_prefix.chomp("/")
      target_base   = SiteSetting.path_proxy_target_base
      enabled       = SiteSetting.path_proxy_enabled

      unless enabled && (req.path == source_prefix || req.path.start_with?(source_prefix + "/"))
        return @app.call(env)
      end

      Rails.logger.warn "[path_proxy] proxying #{req.fullpath} -> #{target_base}"

      target_uri = URI(target_base)
      backend_url = build_backend_url(req, source_prefix, target_base)

      env["HTTP_HOST"]       = target_uri.host
      env["SERVER_PORT"]     = target_uri.port.to_s
      env["rack.url_scheme"] = target_uri.scheme
      env["REQUEST_URI"]     = backend_url.request_uri
      env["PATH_INFO"]       = backend_url.path
      env["QUERY_STRING"]    = backend_url.query.to_s
      env.delete("HTTP_ACCEPT_ENCODING")

      super(env)
    end

    private

    def build_backend_url(req, source_prefix, target_base)
      suffix = req.path.sub(source_prefix, "")
      suffix = "/" if suffix.empty?
      URI.join(target_base, suffix + (req.query_string.empty? ? "" : "?#{req.query_string}"))
    end
  end
end
