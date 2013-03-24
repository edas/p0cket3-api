module P0cket3
  module Error
    class PocketError < RuntimeError
      def initialize(env)
        @env = env
      end

      def raise_error
        raise self, ("Pocket API error: " + message)
      end

      def message
        @env[:response_headers]['X-Error'] || @env[:status]
      end

    end

    class ClientError < PocketError
    end

    class InvalidRequest < ClientError
    end
    class MissingConsumerKey < InvalidRequest
    end
    class MissingRedirectUri < InvalidRequest
    end
    class InvalidRedirectUri < InvalidRequest
    end
    class MissingCode < InvalidRequest
    end
    class CodeNotFound < InvalidRequest
    end

    class AuthenticationError < ClientError
    end

    class AccessDenied < ClientError
    end
    class InvalidConsumerKey < AccessDenied
    end
    class UserRejectedCode < AccessDenied
    end
    class AlreadyUsedCode < AccessDenied
    end
    class TooManyRequests < AccessDenied
    end

    class NotFound < ClientError
    end

    class UnknownClientError < ClientError
    end

    class ServerError < PocketError
    end

  end

end
