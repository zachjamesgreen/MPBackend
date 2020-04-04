class IndexController < ApplicationController

  def index
    @songs = Song.joins(:artist, :album).all
  end
end
