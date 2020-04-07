class PlayerapiController < ApplicationController
  # before_action :set_params

  def songs
    artist
    album
    # TODO: add playlists
    s = Song.all.left_outer_joins(:artist, :album)
              .select('songs.id, artists.id as artist_id, artists.name as artist, albums.id as album_id, albums.name as album_title, songs.name')
    render json: s
  end

  def songs_by_artist
    s = Song.all.left_outer_joins(:artist, :album)
              .select('songs.id, artists.id as artist_id, artists.name as artist, albums.id as album_id, albums.name as album_title, songs.name')
              .where("artists.id = ?", params[:id])
    render json: s
  end

  def songs_by_album
    s = Song.all.left_outer_joins(:artist, :album)
              .select('songs.id, artists.id as artist_id, artists.name as artist, albums.id as album_id, albums.name as album_title, songs.name')
              .where("albums.id = ?", params[:id])
    render json: s

  end

  # def songs_by_playlist
  #   s = Song.all.left_outer_joins(:artist, :album)
  #             .select('songs.id, artists.id as artist_id, artists.name as artist, albums.id as album_id, albums.name as album_title, songs.name')
  #             .where("albums.id = 29")
  #   render json: s
  # end

  def album
    album = Album.find(params[:id])
    render json: album, include: [:songs]
  end

  # GET Albums for artist by id
  def albums
    if params[:artist_id]
      albums = Artist.find(params[:artist_id]).albums
    else
      albums = Album.all
    end
    render json: albums, include: [:songs]
  end

  def artist
    artist = Artist.find(params[:id])
    render json: artist, include: [:albums, :songs]
  end

  # If called will give all albums and songs for each album
  def artists
    # TODO: add param for albums and songs
    a = Artist.all
    render json: a
  end

  def search
    # TODO: make query safe
    if params[:q]
      query = params[:q]
      artists = Artist.where("name ILIKE ?", "#{query}%")
      albums = Album.where("name ILIKE ?", "#{query}%")
      songs = Song.where("name ILIKE ?", "#{query}%")
      render json: {artists: artists, albums: albums, songs: songs}
    end
  end

end
