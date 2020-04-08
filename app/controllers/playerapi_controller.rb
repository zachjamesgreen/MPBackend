class PlayerapiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def songs
    # TODO: add playlists
    render json: Song.all
    # s = Song.all.left_outer_joins(:artist, :album)
    #           .select('songs.id, artists.id as artist_id, artists.name as artist, albums.id as album_id, albums.name as album_title, songs.name')
    # render json: s
  end

  def songs_by_artist
    s = Song.where("artist_id = ?", params[:id])
    render json: s
  end

  def songs_by_album
    s = Song.where("album_id = ?", params[:id])
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
    render json: album
  end

  # GET Albums for artist by id of all Albums
  def albums
    if params[:artist_id]
      albums = Artist.find(params[:artist_id]).albums
    else
      albums = Album.all
    end
    render json: albums
  end

  def artist
    artist = Artist.find(params[:id])
    render json: artist
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

  def upload_songs
    require "id3tag"
    ActionController::Parameters.permit_all_parameters = true

    uploaded_files = request.POST
    uploaded_files.each do |f|
      pp f[1]
      data = extract_tags(f[1].tempfile)
      pp data
      artist,album,song = save_to_db(data)
      copy_file(artist,album,song,f[1])
    end

    head :ok
  end

  private
  def extract_tags(file)
    data = Hash.new
    mp3_file = File.open(file, "rb")
    tag = ID3Tag.read(mp3_file)
    data[:title] = tag.title
    data[:artist] = tag.artist
    data[:album] = tag.album
    data[:year] = tag.year
    data[:track_nr] = tag.track_nr
    data[:genre] = tag.genre
    return data
  end

  def save_to_db(data)
    artist = Artist.find_or_initialize_by(name: data[:artist])
    if artist.new_record?
      artist.name = data[:artist]
      artist.save
    end

    album = Album.find_or_initialize_by(name: data[:album])
    if album.new_record?
      album.artist = artist
      album.name = data[:album]
      album.year = data[:year]
      album.genre = data[:genre]
      album.save
    end

    song = Song.find_or_initialize_by(name: data[:title], artist: artist, album: album)
    if song.new_record?
      song.artist = artist
      song.album = album
      song.name = data[:title]
      song.track_nr = data[:track_nr]
      song.save
    end
    return [artist,album,song]
  end

  def copy_file(artist,album,song,fi)
    loc = "/var/www/html/#{artist.name}/#{album.name}"

    if Dir.exist?(loc) == false
      pp FileUtils.mkdir_p(loc)
    end

    File.open(loc + "/#{song.name}.mp3", 'wb') do |f|
      pp "### File Open Uploading  ###"
      f.write(fi.read)
    end
  end

end
