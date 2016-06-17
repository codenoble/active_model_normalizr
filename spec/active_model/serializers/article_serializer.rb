class ArticleSerializer < ActiveModel::Serializer
  attributes :title, :content, :published
  has_many :comments
  has_many :likes
  has_one :photo

  def published
    true
  end
end
