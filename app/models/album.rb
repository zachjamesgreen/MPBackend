class Album < ApplicationRecord
  include ActiveModel::Serializers::JSON
  belongs_to :artist
  has_many :songs


  def attributes
    {'id' => :id, 'name' => :name, 'artist' => :artist, 'year' => :year}
  end
end
