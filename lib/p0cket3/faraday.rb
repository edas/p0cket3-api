require 'faraday'
require 'p0cket3/faraday/response/pocket_error.rb'
require 'p0cket3/faraday/request/add_header.rb'

::Faraday::Response.register_middleware pocket_error: P0cket3::Faraday::Response::PocketError
::Faraday::Request.register_middleware add_header: P0cket3::Faraday::Request::AddHeader

