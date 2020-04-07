class IndexController < ApplicationController

  def index
    @songs = Song.includes(:artist, :album).all
  end
end
