class ArticleSerializer < ActiveModel::Serializer
  attributes :title, :content, :published, :created_at
  has_many :comments
  has_many :likes
  has_one :photo

  def published
    true
  end

  def created_at
    Time.at(1170361845)
  end
end
