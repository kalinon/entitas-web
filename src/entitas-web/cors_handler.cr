require "kemal"

class Entitas::Web::CorsHandler < Kemal::Handler
  class CorsError < Exception
  end

  # only ["/"], "OPTIONS"

  def call(env)
    if env.request.method == "OPTIONS"
      send_options(env)
    else
      process_cors(env)
    end
    call_next(env)
  end

  def send_options(env)
    env.response.headers.add "Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, urn, catalog_urn"
    env.response.headers.add "Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE"
    env.response.headers.add "Access-Control-Allow-Origin", "*"
  end

  def process_cors(env)
    if env.request.headers["Access-Control-Request-Headers"]?
      env.response.headers.add("Access-Control-Allow-Headers", env.request.headers["Access-Control-Request-Headers"])
    end

    if env.request.headers["Origin"]?
      env.response.headers.add("Access-Control-Allow-Origin", env.request.headers["Origin"])
    else
      env.response.headers.add("Access-Control-Allow-Origin", "*")
    end

    if env.request.headers["Access-Control-Request-Method"]?
      env.response.headers.add("Access-Control-Allow-Methods", env.request.headers["Access-Control-Request-Method"])
    end
  end
end

add_handler Entitas::Web::CorsHandler.new
