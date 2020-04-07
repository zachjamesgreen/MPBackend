class Song < ApplicationRecord
  include ActiveModel::Serializers::JSON
  belongs_to :artist
  belongs_to :album

  def attributes
    {'id' => :id, 'name' => :name, 'track_nr' => :track_nr, 'artist' => :artist, 'album' => :album}
  end
end
