module P0cket3
  module Faraday
    module Response
      class PocketError < ::Faraday::Response::Middleware

        ClientErrors = 400...599

        Errors = {
          400..400 => {
            "138" => Error::MissingConsumerKey,
            "140" => Error::MissingRedirectUri,
            "181" => Error::InvalidRedirectUri,
            "182" => Error::MissingCode,
            "185" => Error::CodeNotFound,
            "default" => Error::InvalidRequest
          },
          401..401 => {
            "default" => Error::AuthenticationError
          },
          403..403 => {
            "152" => Error::InvalidConsumerKey,
            "158" => Error::UserRejectedCode,
            "159" => Error::AlreadyUsedCode,
            "160" => Error::TooManyRequests,
            "default" => Error::AccessDenied
          },
          404..404 => {
            "default" => Error::NotFound
          },
          405..499 => {
            "default" => Error::UnknownClientError
          },
          500..599 => {
            "default" => Error::ServerError
          }
        }

        def on_complete(env)
          return unless ClientErrors.include? env[:status]
          Errors.each do |status, errors|
            if status.include? env[:status]
              code = env[:response_headers]['X-Error-Code']
              error_class = errors[code] || errors["default"]
              error_class.new(env).raise_error
            end

          end
        end

      end
    end
  end
end
