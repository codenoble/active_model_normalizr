class ArticleSerializer < ActiveModel::Serializer
  attributes :title, :content
  has_many :comments
  has_many :likes
  has_one :photo
end
