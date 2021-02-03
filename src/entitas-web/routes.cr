require "./ext"

# :nodoc:
def not_found_resp(env, msg)
  env.response.status_code = 404
  env.response.print ({code: 404, message: msg}.to_json)
  env.response.close
end

before_all do |env|
  env.response.content_type = "application/json"
end

options "/*" do
  # TODO: what should OPTIONS requests actually respond with?
  {msg: "ok"}.to_json
end

get "/healthz" do
  {status: "ok"}.to_json
end

require "./routes/*"