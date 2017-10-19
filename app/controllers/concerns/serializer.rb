module Serializer
  extend ActiveSupport::Concern
    
  def serialized object
    ActiveModelSerializers::SerializableResource.new(object).serializable_hash
  end

end