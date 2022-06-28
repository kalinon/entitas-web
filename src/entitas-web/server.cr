require "kemal"
require "./routes"

module Entitas
  abstract class Controller
    def start_server(args = Array(String).new)
      ENTITAS_WEB_SHARED.controller = self

      spawn do
        Kemal.run(args)
      end
    end
  end
end
