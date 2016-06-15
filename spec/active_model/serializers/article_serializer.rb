class ArticleSerializer < ActiveModel::Serializer
  attributes :title, :content
  has_many :comments
end
