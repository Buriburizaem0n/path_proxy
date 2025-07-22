PathProxy::Engine = ::Rails::Engine.new
Discourse::Application.routes.append do
  # 把 /path/* 交给 middleware；这里占位，避免其它路由匹配
  match "#{SiteSetting.path_proxy_source_prefix}/*all", to: proc { [200, {}, [""]] }, via: :all
end
