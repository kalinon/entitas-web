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

  def _comp_groups(comp_name)
    i = component_names.index(comp_name)
    if i
      groups_for_index[i]
    end
  end

  def _comp_pools(comp_name)
    i = component_names.index(comp_name)
    if i
      component_pools[i]
    end
  end
end
