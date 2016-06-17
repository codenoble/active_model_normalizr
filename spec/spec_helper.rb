require 'bundler/setup'
require 'rspec'
require 'active_model_serializers'
require 'active_record'
require 'sqlite3'
require 'pry'
require 'active_model_serializers/adapter/normalizr'
require './spec/db/migrate/create_test_tables'
require './spec/active_model/serializers/article_serializer'
require './spec/active_model/serializers/comment_serializer'
require './spec/active_model/serializers/photo_serializer'
require './spec/active_record/models/article'
require './spec/active_record/models/comment'
require './spec/active_record/models/photo'
require './spec/active_record/models/like'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'spec/db/active_model_normalizr_test.sqlite3'
)

ActiveModelSerializers.config.adapter = ActiveModelSerializers::Adapter::Normalizr

RSpec.configure do |config|
  config.before(:all) do
    CreateTestTables.migrate(:up)
  end

  config.after(:all) do
    CreateTestTables.migrate(:down)
  end
end
