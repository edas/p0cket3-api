require 'active_support/core_ext'

module P0cket3
  module Authentication

    def request_token(options={})
      options = self.options.deep_merge(options)
      return options[:request_token] if options[:request_token]
      params = {
        consumer_key: options[:consumer_key],
        redirect_uri: options[:redirect_uri]
      }
      connection.post( options[:request_token_path], params).body["code"]
    end

    def request_token!(options={})
      self.options[:request_token] = request_token(options)
    end

    def authorize_url(options={})
      options = self.options.deep_merge(options)
      options[:authorize_url] ||= options[:endpoint] + options[:authorize_url_path]
      options[:authorize_url] += "?" unless options[:authorize_url].match(/\?/)
      options[:authorize_url] + URI.encode_www_form(
        request_token: options[:request_token],
        redirect_uri: options[:redirect_uri]
      ).to_s
    end

    def access_token(options={}, bang=false)
      options = self.options.deep_merge(options)
      return options[:access_token] if options[:access_token]
      name = "access_token_and_username"
      name += "!" if bang
      send(name.to_sym, options)[:access_token]
    end

    def access_token!(options={})
      access_token(options, true)
    end

    def username(options={}, bang=false)
      options = self.options.deep_merge(options)
      return options[:username] if options[:username]
      name = "access_token_and_username"
      name += "!" if bang
      send(name.to_sym, options)[:username]
    end

    def username!(options={})
      username(options, true)
    end

    def access_token_and_username(options={})
      options = self.options.deep_merge(options)
      if options[:username] and options[:access_token]
        {
          username: options[:username],
          access_token: options[:access_token]
        }
      else
        params = {
          consumer_key: options[:consumer_key],
          code: options[:request_token]
        }
        data = connection.post( options[:access_token_path], params).body
        {
          username: data["username"],
          access_token: data["access_token"]
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
