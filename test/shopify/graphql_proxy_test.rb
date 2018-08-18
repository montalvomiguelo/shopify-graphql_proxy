require "test_helper"

class Shopify::GraphQLProxyTest < Minitest::Test
  def setup
    @app = lambda { |env| [200, {"Content-Type" => "text/plain"}, ["All responses are OK"]] }
    @middleware = Shopify::GraphQLProxy.new(@app)
  end

  def test_env_is_not_rewritten_when_request_path_is_not_graphql
    response = Rack::MockRequest.new(@middleware).get("/graphql")

    assert_equal 200, response.status
    assert_equal "All responses are OK", response.body
  end

  def test_env_is_not_rewritten_when_request_method_is_not_post
    response = Rack::MockRequest.new(@middleware).get("/graphql")

    assert_equal 200, response.status
    assert_equal "All responses are OK", response.body
  end

  def test_response_is_403_unauthorized_when_session_does_not_exist
    response = Rack::MockRequest.new(@middleware).post("/graphql")

    assert 402, response.status
    assert_equal "Unauthorized", response.body
  end

  def test_proxy_graphql_request_to_shopify_when_session_exists
    opts = {
      "rack.session" => {
        :shopify => {
          :shop => "snowdevil.myshopify.com",
          :token => "23"
        }
      }
    }

    browser = Rack::Test::Session.new(Rack::MockSession.new(@middleware))
    browser.post("/graphql", {}, opts)

    assert_equal "snowdevil.myshopify.com", browser.last_request.get_header("HTTP_HOST")
    assert_equal "/admin/api/graphql.json", browser.last_request.get_header("PATH_INFO")
    assert_equal "23", browser.last_request.get_header("HTTP_X_SHOPIFY_ACCESS_TOKEN")
    assert_equal "", browser.last_request.get_header("SCRIPT_NAME")
    assert_nil browser.last_request.get_header("HTTP_COOKIE")
  end
end
