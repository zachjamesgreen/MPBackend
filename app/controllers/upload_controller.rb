class UploadController < ApplicationController
  require "id3tag"

  def new

  end

  def upload
    uploaded_file = params[:file]
    data = extract_tags(uploaded_file.tempfile)
    pp data

    # File.open("../music/" + uploaded_file.original_filename, 'wb') do |file|
    #   pp "### File Open Uploading  ###"
    #   file.write(uploaded_file.read)
    # end

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
end
