class PlayerapiController < ApplicationController

  def songs
    s = ActiveRecord::Base.connection.execute("
      SELECT songs.id, artists.id as artist_id, artists.name as artist, albums.id as album_id, albums.name as album_title, songs.name
      FROM songs
      LEFT OUTER JOIN artists ON artists.id = songs.artist_id
      LEFT OUTER JOIN albums ON albums.id = songs.album_id")
    render json: s

    # render json: Song.joins(:album, :artist)
  end

  def album
    a = Album.find(params[:id])
    s = a.songs
    a = a.as_json
    a[:songs] = s
    render json: a
  end

  def albums
    a = Album.all
    render json: a
  end

  def artist
    a = Artist.find(params[:id])
    b = {
      :id => a.id,
      :name => a.name,
      :albums => a.albums
    }

    render json: b
  end

  def artists
    a = Artist.all
    render json: a
  end

end
