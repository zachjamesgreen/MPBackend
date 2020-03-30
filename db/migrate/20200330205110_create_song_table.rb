class CreateSongTable < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.belongs_to(:artist, foreign_key: true)
      t.belongs_to(:album, foreign_key: true)
      t.string :name, null: false
      t.integer :track_nr
    end
  end
end
