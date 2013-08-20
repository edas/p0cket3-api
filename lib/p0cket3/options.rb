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

    def with_options(options={}, needed=[], or_having=nil)
      options = self.options.deep_merge(options)
      needed.each do |key|
        unless options.has_key?(key)
          method = /`([^'])'$/.match(caller(1)[0])[1]
          raise Error::MissingParameter, "Missing #{key} in parameters in #{method} from P0cket3"
        end
      end unless (or_having and options.has_key?(or_having))
      options
    end

    [
      :redirect_uri,
      :consumer_key,
      :request_token,
      :access_token,
      :username,
      :state
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
