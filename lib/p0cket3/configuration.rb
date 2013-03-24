require 'active_support'
require 'faraday'

module P0cket3
  DEFAULTS = {
    endpoint: "https://getpocket.com",
    ssl: { verify: true },
    adaptater: Faraday.default_adapter,
    request_token_path: "/v3/oauth/request",
    authorize_url_path: "/auth/authorize",
    authorize_ios_url: "pocket-oauth-v1:///authorize",
    access_token_path: "/v3/oauth/authorize",
    retrieve_path: "/v3/get",
    item_factory: ->(data){ P0cket3::Item.import(data) },
    new_retrieve_request: ->{ P0cket3::RetrieveRequest.new },
    redirect_uri: "http://www.example.org/",

    consumer_key: "12356-3e55665efe5bf9b479556a45",
    access_token: "035bea61-1d0d-326e-aac4-e28103",
  }
end
