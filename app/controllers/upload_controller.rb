class UploadController < ApplicationController
  require "id3tag"

  def new

  end

  def upload
    # TODO: get song file type
    uploaded_file = params[:file]
    data = extract_tags(uploaded_file.tempfile)

    artist = Artist.find_or_initialize_by(name: data[:artist])
    if artist.new_record?
      artist.name = data[:artist]
      artist.save
    end

    album = Album.find_or_initialize_by(name: data[:album], artist: artist)
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
      copy_file(artist,album,song,uploaded_file)
    end
  end

  private
  # Takes File location and returns Hash of tag data
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

  def copy_file(artist,album,song,fi)
    loc = "../music/#{artist.name}/#{album.name}"

    if Dir.exist?(loc) == false
      pp FileUtils.mkdir_p(loc)
    end

    File.open(loc + "/#{song.name}.mp3", 'wb') do |f|
      pp "### File Open Uploading  ###"
      f.write(fi.read)
    end
  end
end
