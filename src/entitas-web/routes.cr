require "./ext"

# :nodoc:
private def not_found_resp(env, msg)
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

get "/api/v1/contexts" do
  Entitas::Contexts.shared_instance.all_contexts.map { |c| c.context_info }.to_json
end

get "/api/v1/contexts/:name" do |env|
  name = env.params.url["name"]
  context = Entitas::Contexts.shared_instance.all_contexts.find { |c| c.context_info.name == name }
  if context
    context._summary.to_json
  else
    not_found_resp(env, "Not found")
  end
end

get "/api/v1/contexts/:name/entities" do |env|
  name = env.params.url["name"]
  context = Entitas::Contexts.shared_instance.all_contexts.find { |c| c.context_info.name == name }
  if context
    context.get_entities.to_json
  else
    not_found_resp(env, "Not found")
  end
end

get "/api/v1/contexts/:name/groups/:comp" do |env|
  name = env.params.url["name"]
  comp_name = env.params.url["comp"]

  context = Entitas::Contexts.shared_instance.all_contexts.find { |c| c.context_info.name == name }
  if context
    g = context._comp_groups(comp_name)
    g.to_json
  else
    not_found_resp(env, "Not found")
  end
end

get "/api/v1/contexts/:name/pools/:comp" do |env|
  name = env.params.url["name"]
  comp_name = env.params.url["comp"]

  context = Entitas::Contexts.shared_instance.all_contexts.find { |c| c.context_info.name == name }
  if context
    g = context._comp_pools(comp_name)
    g.to_json
  else
    not_found_resp(env, "Not found")
  end
end
