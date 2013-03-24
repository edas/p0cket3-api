module P0cket3
  module Faraday
    module Request
      class AddHeader < ::Faraday::Middleware

        def initialize(app, options)
          super(app)
          @headers = options
        end

        def call(env)
          @headers.each do |key,value|
            key = normalize(key)
            env[:request_headers][key] = value
          end
          @app.call env
        end

      protected

        def normalize(key)
          key.to_s.split('_').            # :user_agent => %w(user agent)
            each { |w| w.capitalize! }.   # => %w(User Agent)
            join('-')                     # => "User-Agent"
        end

      end
    end
  end
end
