require 'spec_helper'

describe ActiveModelSerializers::Adapter::Normalizr do
  let!(:article) { Article.create! title: 'Dunno', content: 'Lorem ipsum...' }
  let(:serializee) { article }

  subject { ActiveModelSerializers::SerializableResource.new(serializee).as_json }
  let(:result) { subject['result'] }
  let(:entities) { subject['entities'] }
  let(:articles) { entities['articles'] }
  let(:comments) { entities['comments'] }
  let(:likes) { entities['likes'] }
  let(:photos) { entities['photos'] }

  before do
    Article.delete_all
    Comment.delete_all
    Like.delete_all
    Photo.delete_all
  end

  context 'when a model' do
    describe '#serializable_hash' do
      context 'without associated models' do
        it 'returns a hash' do
          expect(subject).to be_a Hash
        end

        it 'contains a result' do
          expect(subject).to have_key 'result'
          expect(result).to eql article.id
        end

        it 'contains entries' do
          expect(subject).to have_key 'entities'
          expect(entities).to have_key 'articles'
        end

        it 'includes the model attributes' do
          expect(articles.keys.length).to be 1
          expect(articles[article.id]['title']).to eql 'Dunno'
          expect(articles[article.id]['content']).to eql 'Lorem ipsum...'
        end
      end

      context 'with a has_one association' do
        let!(:photo) { Photo.create! article: article, url: 'http://lorempixel.com/100/100/' }

        it 'serializes the associated model' do
          expect(entities).to have_key 'photos'
          expect(photos).to have_key photo.id
          expect(photos[photo.id]['url']).to eql 'http://lorempixel.com/100/100/'
        end
      end

      context 'with a has_many association' do
        context 'when the association has a serializer' do
          let!(:comment) { Comment.create! article: article, comment: 'Meh' }

          it 'serializes the associated model' do
            expect(entities).to have_key 'comments'
            expect(comments).to have_key comment.id
            expect(comments[comment.id]['comment']).to eql 'Meh'
          end
        end

        context 'when the association has no serializer' do
          let!(:like) { Like.create! article: article, username: 'milton' }

          it 'serializes the associated model' do
            expect(entities).to have_key 'likes'
            expect(likes).to have_key like.id
            expect(likes[like.id]['username']).to eql 'milton'
          end
        end
      end
    end
  end

  context 'when a colleciton' do
    let!(:article_a) { Article.create! title: 'One', content: 'First...' }
    let!(:article_b) { Article.create! title: 'Two', content: 'Second...' }
    let!(:comment_a) { Comment.create! article: article_a, comment: 'Meh' }
    let!(:comment_b) { Comment.create! article: article_b, comment: 'Yay' }
    let(:serializee) { Article.all }

    describe '#serializable_hash' do
      it 'returns a hash' do
        expect(subject).to be_a Hash
      end

      it 'contains a result' do
        expect(subject).to have_key 'result'
        expect(result).to be_an Array
        expect(result.sort).to eql [article_a.id, article_b.id].sort
      end

      it 'contains entries' do
        expect(subject).to have_key 'entities'
        expect(entities).to have_key 'articles'
      end

      it "includes the first models' attributes" do
        expect(articles.keys.length).to be 2
        expect(articles[article_a.id]['title']).to eql 'One'
        expect(articles[article_a.id]['content']).to eql 'First...'
      end

      it "includes the second models' attributes" do
        expect(articles[article_b.id]['title']).to eql 'Two'
        expect(articles[article_b.id]['content']).to eql 'Second...'
      end
    end
  end
end
