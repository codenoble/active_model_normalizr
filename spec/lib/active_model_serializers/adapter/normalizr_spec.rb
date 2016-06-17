require 'spec_helper'

describe ActiveModelSerializers::Adapter::Normalizr do
  let!(:article) { Article.create! title: 'Dunno', content: 'Lorem ipsum...' }
  let(:serializee) { article }

  subject { ActiveModelSerializers::SerializableResource.new(serializee).as_json }
  let(:result) { subject['result'] }
  let(:entities) { subject['entities'] }

  before do
    Article.delete_all
    Comment.delete_all
    Like.delete_all
    Photo.delete_all
  end

  context 'when a model' do
    describe '#serializable_hash' do
      context 'without associated models' do
        it 'returns a normalizr-like hash' do
          expect(subject).to be_a Hash
          expect(subject).to have_key 'result'
          expect(result).to eql article.id
          expect(subject).to have_key 'entities'
          expect(entities).to have_key 'articles'
          expect(entities['articles'].keys.length).to be 1
          expect(entities['articles'][article.id]['title']).to eql 'Dunno'
          expect(entities['articles'][article.id]['content']).to eql 'Lorem ipsum...'
        end
      end

      context 'with a has_one association' do
        let!(:photo) { Photo.create! article: article, url: 'http://lorempixel.com/100/100/' }

        it 'serializes the associated model' do
          expect(entities).to have_key 'photos'
          expect(entities['photos']).to have_key photo.id
          expect(entities['photos'][photo.id]['url']).to eql 'http://lorempixel.com/100/100/'
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
      it 'returns a normalizr-like hash' do
        expect(subject).to be_a Hash
        expect(subject).to have_key 'result'
        expect(subject['result']).to be_an Array
        expect(subject['result'].sort).to eql [article_a.id, article_b.id].sort
        expect(subject).to have_key 'entities'
        expect(subject['entities']).to have_key 'articles'
        expect(subject['entities']['articles'].keys.length).to be 2
        expect(subject['entities']['articles'][article_a.id]['title']).to eql 'One'
        expect(subject['entities']['articles'][article_a.id]['content']).to eql 'First...'
        expect(subject['entities']['articles'][article_b.id]['title']).to eql 'Two'
        expect(subject['entities']['articles'][article_b.id]['content']).to eql 'Second...'
        expect(subject['entities']['comments'][comment_a.id]['comment']).to eql 'Meh'
        expect(subject['entities']['comments'][comment_b.id]['comment']).to eql 'Yay'
      end
    end
  end
end
