require 'active_support/core_ext'

module P0cket3
  module Options

    attr_accessor :options

    def initialize(options={})
      self.options = DEFAULTS.deep_merge(options)
    end

    def merge(options)
      self.options = self.options.deep_merge(options)
    end

    [
      :redirect_uri,
      :consumer_key,
      :request_token,
      :access_token,
      :username
    ].each do |m|
      define_method "#{m.to_s}=".to_sym do |val|
        options[m] = val
      end
    end

    [
      :redirect_uri,
      :consumer_key,
      :username
    ].each do |m|
      define_method m do
        options[m]
      end
    end

  end
end
