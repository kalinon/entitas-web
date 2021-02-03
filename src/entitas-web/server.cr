require "kemal"
require "./routes"

module Entitas
  abstract class Controller
    def start_server
      spawn do
        Kemal.run
      end
    end
  end
end
