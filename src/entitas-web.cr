module Entitas::Web
  # :nodoc:
  class Shared
    property controller : Entitas::Controller? = nil
  end
end

# :nodoc:
ENTITAS_WEB_SHARED = Entitas::Web::Shared.new

# :nodoc:
def web_contexts
  ENTITAS_WEB_SHARED.controller.not_nil!.contexts
end

# :nodoc:
def web_controller
  ENTITAS_WEB_SHARED.controller.not_nil!
end

require "./entitas-web/*"