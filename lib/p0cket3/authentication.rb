require 'active_support/core_ext'

module P0cket3
  module Authentication

    def request_token(options={})
      options = with_options(options, [:consumer_key, :redirect_uri])
      return options[:request_token] if options[:request_token]
      params = {
        consumer_key: options[:consumer_key],
        redirect_uri: options[:redirect_uri]
      }
      JSON.generate(options[:state]) if options[:state]
      connection.post( options[:request_token_path], params).body["code"]
    end

    def request_token!(options={})
      self.options[:request_token] = request_token(options)
    end

    def authorize_url(options={})
      options = with_options(options, [:consumer_key, :request_token, :redirect_uri])
      options[:authorize_url] ||= options[:endpoint] + options[:authorize_url_path]
      options[:authorize_url] += "?" unless options[:authorize_url].match(/\?/)
      options[:authorize_url] + URI.encode_www_form(
        request_token: options[:request_token],
        redirect_uri: options[:redirect_uri]
      ).to_s
    end

    def access_token(options={}, bang=false)
      options = with_options(options, [:consumer_key, :request_token], :access_token)
      return options[:access_token] if options[:access_token]
      name = "access_token_and_username"
      name += "!" if bang
      send(name.to_sym, options)[:access_token]
    end

    def access_token!(options={})
      access_token(options, true)
    end

    def state(options={}, bang=false)
      options = with_options(options, [:consumer_key, :request_token], :access_token)
      return options[:access_token] if options[:access_token]
      name = "access_token_and_username"
      name += "!" if bang
      send(name.to_sym, options)[:state]
    end

    def state!(options={})
      state(options, true)
    end

    def username(options={}, bang=false)
      options = with_options(options, [:consumer_key, :request_token], :username)
      return options[:username] if options[:username]
      name = "access_token_and_username"
      name += "!" if bang
      send(name.to_sym, options)[:username]
    end

    def username!(options={})
      username(options, true)
    end

    def access_token_and_username(options={})
      options = with_options(options, [:consumer_key, :request_token])
      if options[:username] and options[:access_token]
        {
          username: options[:username],
          access_token: options[:access_token],
          state: options[:state]
        }
      else
        params = {
          consumer_key: options[:consumer_key],
          code: options[:request_token]
        }
        data = connection.post( options[:access_token_path], params).body
        {
          username: data["username"],
          access_token: data["access_token"],
          state: (data["state"] ? JSON.parse(data["state"]) : nil)
        }
      end
    end

    def access_token_and_username!(options={})
      data = access_token_and_username(options)
      merge(data)
      data
    end

  end
end
