private def entity_short(ent)
  {
    name:           ent.to_s,
    creation_index: ent.creation_index,
    context:        ent.context_info.name,
    components:     ent.get_components.reject(Nil),
    retain_count:   ent.retain_count,
  }
end

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
      groups_for_index[i].map do |g|
        {
          matcher:  g.matcher.to_s,
          entities: g.entities.map { |ent| entity_short(ent) },
        }
      end
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
    n = _systems.flat_map do |s|
      s.is_a?(Entitas::Systems) ? s._sub_system_names : Array(String).new
    end.uniq!
    (n + _systems.map(&._name)).uniq
  end

  # :nodoc:
  def _systems
    self.cleanup_systems + self.execute_systems + self.initialize_systems + self.tear_down_systems
  end

  # :nodoc:
  def to_json(json : JSON::Builder)
    json.object do
      json.field("name", self._name)
      # json.field("class", self.class.to_s)
      json.field("systems", _systems)
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

class Entitas::Group(TEntity)
  def to_json(json)
    json.object do
      json.field "matcher", matcher
      json.field "entities", get_entities.map { |ent| entity_short(ent) }
    end
  end
end
