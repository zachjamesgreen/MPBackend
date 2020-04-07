class Album < ApplicationRecord
  belongs_to :artist
  has_many :songs


  def add_songs
  end
end
