abstract class Entitas::Context
  # :nodoc:
  def _summary
    {
      name:              name,
      total_entities:    size,
      components:        component_names,
      creation_index:    creation_index,
      reusable_entities: reusable_entities.size,
      retained_entities: retained_entities.size,
      # groups_for_index:  groups_for_index,
      # component_pools: component_pools,
    }
  end

  # :nodoc:
  def _comp_groups(comp_name)
    i = component_names.index(comp_name)
    if i
      groups_for_index[i]
    end
  end

  # :nodoc:
  def _comp_pools(comp_name)
    i = component_names.index(comp_name)
    if i
      component_pools[i]
    end
  end
end

# :nodoc:
class Entitas::Controller
  # :nodoc:
  def _systems
    self.systems
  end
end

module Entitas::System
  def _name
    self.class.to_s
  end
end

# :nodoc:
class Entitas::Systems
  def _name
    self.class.to_s
  end

  # :nodoc:
  def _sub_system(sub_name)
    return self if self._name == sub_name

    _systems.each do |s|
      return s if s._name == sub_name
      sys = s.is_a?(Entitas::Systems) ? s._sub_system(sub_name) : nil
      return sys unless sys.nil?
    end

    nil
  end

  def _sub_system_names
    n = _systems.map do |s|
      s.is_a?(Entitas::Systems) ? s._sub_system_names : Array(String).new
    end.flatten.uniq
    (n + _systems.map { |s| s._name }).uniq

    # _sub_systems.map { |s| s.class.to_s }
  end

  # :nodoc:
  def _systems
    self.cleanup_systems + self.execute_systems + self.initialize_systems + self.tear_down_systems
  end

  # :nodoc:
  def to_json(json : JSON::Builder)
    json.object do
      json.field("name", self._name)
      json.field("systems", _systems)
      # json.field("systems", {
      #   cleanup:    self.cleanup_systems,
      #   execute:    self.execute_systems.map { |s| {
      #     name: s.class.to_s,
      #     reactive: s.is_a?(Entitas::ReactiveSystem),
      #     # collector: s.is_a?(Entitas::ReactiveSystem) ? s.collector : nil,
      #     multi_reactive: s.is_a?(Entitas::MultiReactiveSystem),
      #     # collectors: s.is_a?(Entitas::MultiReactiveSystem) ? s.collectors : nil,
      #   }},
      #   initialize: self.initialize_systems,
      #   tear_down:  self.tear_down_systems,
      # })
    end
  end
end

class Entitas::ReactiveSystem
  def to_json(json : JSON::Builder)
    json.object do
      json.field("name", self._name)
      json.field("collector", self.collector)
    end
  end
end

class Entitas::MultiReactiveSystem
  def to_json(json : JSON::Builder)
    json.object do
      json.field("name", self._name)
      json.field("collectors", self.collectors)
    end
  end
end
