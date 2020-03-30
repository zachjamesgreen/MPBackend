class CreateArtistTable < ActiveRecord::Migration[6.0]
  def change
    create_table :artists do |t|
      t.string :name, null: false, unique: true
    end
  end
end
