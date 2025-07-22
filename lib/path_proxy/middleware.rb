require "rack/proxy"
require "uri"

module PathProxy
  class Middleware < Rack::Proxy
    def initialize(app, opts = {})
      super(app)
      @app = app
      @source_prefix = (opts[:source_prefix] || "/path").chomp("/")
      @target_base   = opts[:target_base]   || "http://127.0.0.1:8551"
      @target_uri    = URI(@target_base)
    end

    def call(env)
      req = Rack::Request.new(env)

      unless SiteSetting.path_proxy_enabled && proxy_target?(req.path)
        return @app.call(env)
      end

      Rails.logger.warn "[path_proxy] proxying #{req.fullpath} -> #{@target_base}"

      backend_url = build_backend_url(req)
      env["HTTP_HOST"]       = @target_uri.host
      env["SERVER_PORT"]     = @target_uri.port.to_s
      env["rack.url_scheme"] = @target_uri.scheme
      env["REQUEST_URI"]     = backend_url.request_uri
      env["PATH_INFO"]       = backend_url.path
      env["QUERY_STRING"]    = backend_url.query.to_s
      env.delete("HTTP_ACCEPT_ENCODING")

      super(env)
    end

    private

    def proxy_target?(path)
      path == @source_prefix || path.start_with?(@source_prefix + "/")
    end

    def build_backend_url(req)
      suffix = req.path.sub(@source_prefix, "")
      suffix = "/" if suffix.empty?
      URI.join(@target_base, suffix + (req.query_string.empty? ? "" : "?#{req.query_string}"))
    end
  end
end
