class CreateShortUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :short_urls do |t|
      t.string :original_url
      t.string :slug
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.integer :clicks_count, default: 0

      t.timestamps
    end
    add_index :short_urls, :slug, unique: true
  end
end
