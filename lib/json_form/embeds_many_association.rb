class JsonForm::EmbedsManyAssociation < JsonForm::Association
  def assign(data)
    return if data.nil?
    children_ids = assign_data(data)
    delete_children(children_ids)
  end

  private

  def assign_data(data)
    data.map.with_index do |child_data, position|
      child = find_or_build_child(child_data)
      @form_class.new(child, @form_options).attributes = child_data
      child_built(child, child_data, position)
      child.id
    end
  end

  def association
    @association ||= @parent.send(@name)
  end

  def delete_children(children_ids)
    association.each do |child|
      child.mark_for_destruction unless children_ids.include?(child.id)
    end
  end

  def find_or_build_child(child_data)
    find_child(child_data) || build_child(child_data)
  end

  def build_child(child_data)
    association.build(child_build_data(child_data))
  end

  def find_child(child_data)
    association.detect { |target| child_data[:id] == target.id }
  end

  def child_build_data(child_data)
    {id: child_data[:id]}
  end

  def child_built(child, child_data, position)
  end
end
