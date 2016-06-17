class CreateTestTables < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
    end

    create_table :comments do |t|
      t.belongs_to :article
      t.string :comment
      t.datetime :posted_at
    end

    create_table :likes do |t|
      t.belongs_to :article
      t.string :username
    end

    create_table :photos do |t|
      t.belongs_to :article
      t.string :url
    end
  end
end
