class CommentSerializer < ActiveModel::Serializer
  attributes :comment
  belongs_to :article
end
