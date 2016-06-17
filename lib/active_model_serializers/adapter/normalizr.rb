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

    serializers = serializer.respond_to?(:each) ? serializer : Array(serializer)

    serializers.each do |ser|
      # Main object(s) to be serialized
      main_entity_name = ser.json_key.pluralize
      main_entity_id = ser.object.id

      h[main_entity_name] ||= {}
      h[main_entity_name][main_entity_id] = ser.attributes.stringify_keys

      # Associated objects
      ser.associations.each do |assoc|
        entity_name = assoc.name.to_s
        entities_name = entity_name.pluralize
        entity_object = ser.object.send(assoc.name)
        assoc_ids =
          if entity_object.nil?
            nil
          elsif entity_object.respond_to?(:each)
            entity_object.map(&:id)
          else
            entity_object.id
          end

        # Ensure that objects contain ids of their associated models
        h[main_entity_name][main_entity_id][entity_name] = assoc_ids
        h[entities_name] ||= {}

        Array(entity_object).each do |assoc_entity|
          # TODO: use serializer here if possible
          h[entities_name][assoc_entity.id] = assoc_entity.attributes
        end
      end
    end

    h
  end

  def object_key(object)
    if object.is_a? ActiveRecord::Relation
      object.model.model_name.plural
    else
      object.class.model_name.plural
    end
  end
end
