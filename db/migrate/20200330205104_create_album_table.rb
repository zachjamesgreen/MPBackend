class CreateAlbumTable < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.belongs_to(:artist, foreign_key: true)
      t.string :name, null: false
      t.integer :year
      t.string :genre
    end
  end
end
