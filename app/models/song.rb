class Song < ApplicationRecord
  belongs_to :artist
  belongs_to :album


  def songs_with_data

  end
end
