get "/api/v1/contexts" do
  web_contexts.all_contexts.map(&.context_info).to_json
end

get "/api/v1/contexts/:name" do |env|
  name = env.params.url["name"]
  context = web_contexts.all_contexts.find { |c| c.context_info.name == name }
  if context
    context._summary.to_json
  else
    not_found_resp(env, "Not found")
  end
end

get "/api/v1/contexts/:name/entities" do |env|
  name = env.params.url["name"]
  context = web_contexts.all_contexts.find { |c| c.context_info.name == name }
  if context
    context.get_entities.map do |e|
      {
        name:           e.to_s,
        creation_index: e.creation_index,
        context:        e.context_info.name,
        components:     e.get_components.map(&.index.to_s),
      }
    end.to_json
  else
    not_found_resp(env, "Not found")
  end
end

get "/api/v1/contexts/:name/entities/:index" do |env|
  name = env.params.url["name"]
  index = env.params.url["index"].to_i

  context = web_contexts.all_contexts.find { |c| c.context_info.name == name }
  if context
    ent = context.get_entities.find { |e| e.creation_index == index }
    if ent
      {
        name:           ent.to_s,
        creation_index: ent.creation_index,
        context:        ent.context_info.name,
        components:     ent.get_components.reject(Nil),
        retain_count:   ent.retain_count,
      }.to_json
    else
      not_found_resp(env, "Not found")
    end
  else
    not_found_resp(env, "Not found")
  end
end

get "/api/v1/contexts/:name/comp/:comp/groups" do |env|
  name = env.params.url["name"]
  comp_name = env.params.url["comp"]

  context = web_contexts.all_contexts.find { |c| c.context_info.name == name }
  if context
    g = context._comp_groups(comp_name)
    g.to_json
  else
    not_found_resp(env, "Not found")
  end
end

get "/api/v1/contexts/:name/comp/:comp/pools" do |env|
  name = env.params.url["name"]
  comp_name = env.params.url["comp"]

  context = web_contexts.all_contexts.find { |c| c.context_info.name == name }
  if context
    g = context._comp_pools(comp_name)
    g.to_json
  else
    not_found_resp(env, "Not found")
  end
end
