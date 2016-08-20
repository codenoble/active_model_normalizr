class ActiveModelSerializers::Adapter::Normalizr < ActiveModelSerializers::Adapter::Base
  def self.default_key_transform
    :camel_lower
  end

  def serializable_hash(options = nil)
    options = serialization_options(options)

    serialized_hash = {
      'result' => result,
      'entities' => entities(options)
    }

    self.class.transform_key_casing!(serialized_hash, options)
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

        if assoc.serializer.nil?
          Array(assoc.options[:virtual_value]).each do |v_value|
            h[entities_name][v_value['id']] = v_value.stringify_keys
          end
        else
          Array(assoc.serializer).try(:each) do |assoc_ser|
            h[entities_name][assoc_ser.object.id] = assoc_ser.as_json.stringify_keys
          end
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
