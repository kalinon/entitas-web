get "/api/v1/controller" do
  web_controller.to_json
end

macro finished
  SYS_LIST = [
    {% for obj in Object.all_subclasses.sort_by { |a| a.name } %}
      {% if obj.ancestors.includes?(Entitas::System) %}
      {{obj.id.stringify}},
      {% end %}
    {% end %}
  ]
end

get "/api/v1/systems" do |env|
  # sys = web_controller._systems
  # if sys
  #   # sys._sub_system_names.to_json
  #   SYS_LIST.uniq.to_json
  # else
  #   not_found_resp(env, "Not found")
  # end
  SYS_LIST.uniq.to_json
end

get "/api/v1/systems/:name" do |env|
  name = env.params.url["name"]
  sys = web_controller._systems
  if sys
    sys._sub_system(name).to_json
  else
    not_found_resp(env, "Not found")
  end
end
