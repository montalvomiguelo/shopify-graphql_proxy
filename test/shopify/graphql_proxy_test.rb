require "test_helper"

class Shopify::GraphQLProxyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Shopify::GraphQLProxy::VERSION
  end
end
