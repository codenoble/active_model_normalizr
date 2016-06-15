class CreateTestTables < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
    end

    create_table :comments do |t|
      t.belongs_to :article
      t.string :comment
    end

    create_table :likes do |t|
      t.belongs_to :article
      t.string :username
    end
  end
end
