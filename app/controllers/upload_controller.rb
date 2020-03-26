class UploadController < ApplicationController
  def new

  end

  def upload
    uploaded_file = params[:file]
    File.open("../music/" + uploaded_file.original_filename, 'wb') do |file|
      file.write(uploaded_file.read)
    end

  end
end
