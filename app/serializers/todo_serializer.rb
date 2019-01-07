class TodoSerializer < ActiveModel::Serializer
  attributes :id, :label, :is_done
end