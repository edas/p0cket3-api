require 'uri'
require 'faraday'
require 'faraday_middleware'

module P0cket3
  module Connection

    attr_writer :connection

    def connection
      @connection ||= default_connection
    end

    def default_connection
      ::Faraday::Connection.new(options[:endpoint]) do |conn|
        conn.request :json
        conn.request :add_header, {
          content_type: "application/json; charset=UTF8",
          x_accept: "application/json",
          # accept: "application/json"
        }
        conn.response :json, :content_type => /\bjson$/
        conn.response :pocket_error
        conn.adapter ::Faraday.default_adapter
        yield conn if block_given?
      end
    end

  end
end
