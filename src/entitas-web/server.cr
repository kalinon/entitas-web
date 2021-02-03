require "http/server"
require "json"

module Entitas
  abstract class Controller
    def start_server(port = 8080)
      spawn do
        server = HTTP::Server.new do |context|
          context.response.content_type = "application/json"
          context.response.headers["Access-Control-Allow-Origin"] = "*"
          context.response.headers["Access-Control-Allow-Methods"] = "GET"
          context.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
          context.response.print stats.to_json
        end

        puts "Listening on http://0.0.0.0:#{port}"
        server.listen(port)
      end
    end
  end
end
