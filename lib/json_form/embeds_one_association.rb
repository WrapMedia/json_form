class JsonForm::EmbedsOneAssociation < JsonForm::Association
  def assign(data)
    child_class = @parent.class.reflect_on_association(@name).klass
    child = child_class.find_or_initialize_by(id: data[:id])
    @parent.send("#{@name}=", child)
    @form_class.new(child, @form_options).attributes = data
  end
end
