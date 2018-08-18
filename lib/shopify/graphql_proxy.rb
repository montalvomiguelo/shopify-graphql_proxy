require "rack-proxy"

module Shopify
  class GraphQLProxy < Rack::Proxy
    PROXY_BASE_PATH = "/graphql"
    GRAPHQL_PATH = "/admin/api/graphql.json"
    VERSION = "0.1.0"

    def perform_request(env)
      request = Rack::Request.new(env)
      path_info = request.path_info
      request_method = request.request_method

      if path_info =~ %r{^#{PROXY_BASE_PATH}} && request_method == "POST"
        unless request.session.key?(:shopify)
          return ["403", {"Content-Type" => "text/plain"}, ["Unauthorized"]]
        end

        backend = URI("https://#{request.session[:shopify][:shop]}#{GRAPHQL_PATH}")

        env["HTTP_HOST"] = backend.host
        env["PATH_INFO"] = backend.path
        env["HTTP_X_SHOPIFY_ACCESS_TOKEN"] = request.session[:shopify][:token]
        env["SCRIPT_NAME"] = ""
        env["HTTP_COOKIE"] = nil

        super(env)
      else
        @app.call(env)
      end
    end
  end
end
