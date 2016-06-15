class ActiveModelSerializers::Adapter::Normalizr < ActiveModelSerializers::Adapter::Base
  def serializable_hash(options = nil)
    options = serialization_options(options)

    {
      'result' => result,
      'entities' => entities(options)
    }
  end

  private

  def obj
    serializer.object
  end

  def result
    obj.respond_to?(:each) ? obj.map(&:id) : obj.id
  end

  def entities(options = nil)
    h = {}

    objects = obj.respond_to?(:each) ? obj : Array(obj)
    serializers = serializer.respond_to?(:each) ? serializer : Array(serializer)

    serializers.each do |ser|
      key = ser.json_key.pluralize
      h[key] ||= {}
      h[key][ser.object.id] = ser.attributes.stringify_keys

      ser.associations.each do |assoc|
        h[assoc.name.to_s.pluralize] ||= {}

        ser.object.send(assoc.name).each do |assoc_entity|
          # TODO: use serializer here if possible
          h[assoc.name.to_s.pluralize][assoc_entity.id] = assoc_entity.attributes
        end
      end
    end

    h
  end

  # def entity_array
  #   array = []
  #
  #   if obj.respond_to? :to_a
  #     array += obj.to_a
  #   else
  #     array << obj
  #   end
  #
  #   binding.pry
  #   serializer.associations.each do |association|
  #
  #   end
  #
  #   array
  # end
  #
  # def entity_hash(model)
  #   { model.id => model.attributes }
  # end

  def object_key(object)
    if object.is_a? ActiveRecord::Relation
      object.model.model_name.plural
    else
      object.class.model_name.plural
    end
  end
end
