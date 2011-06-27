require 'faraday'
require 'multi_json'

# @api private
module Faraday
  class Response::RaiseGithu3Error < Response::Middleware
    def on_complete(response)
      case response[:status].to_i
      when 400
        raise Githu3::BadRequest, error_message(response)
      when 401
        raise Githu3::Unauthorized, error_message(response)
      when 403
        raise Githu3::Forbidden, error_message(response)
      when 404
        raise Githu3::NotFound, error_message(response)
      when 406
        raise Githu3::NotAcceptable, error_message(response)
      when 422
        raise Githu3::UnprocessableEntity, error_message(response)
      when 500
        raise Githu3::InternalServerError, error_message(response)
      when 501
        raise Githu3::NotImplemented, error_message(response)
      when 502
        raise Githu3::BadGateway, error_message(response)
      when 503
        raise Githu3::ServiceUnavailable, error_message(response)
      end
    end

    def error_message(response)
      if !response[:body].blank?
        body = ::MultiJson.decode(response[:body])
        message = body["error"] || body["message"]
      end
      "#{response[:method].to_s.upcase} #{response[:url].to_s} [#{response[:status]}]: #{message}"
    end
  end
end
