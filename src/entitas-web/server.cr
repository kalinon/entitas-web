require "kemal"
require "./routes"

module Entitas
  abstract class Controller
    def start_server
      ENTITAS_WEB_SHARED.controller = self

      spawn do
        Kemal.run
      end
    end
  end
end
