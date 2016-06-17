class CommentSerializer < ActiveModel::Serializer
  attributes :comment, :spam
  belongs_to :article

  def spam
    false
  end
end
