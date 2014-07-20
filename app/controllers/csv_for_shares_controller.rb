class CsvForSharesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :set_format

  def set_format
    request.format = "html"
  end


  def index

  end

  def create
    uploaded_io = params[:file]
    if uploaded_io.nil?
      redirect_to root_path, :alert => "File failed to upload"
      return
    elsif !File.extname(uploaded_io.original_filename).eql? ".csv"
      redirect_to root_path, :alert => "Wrong file format"
      return
    elsif uploaded_io.size > 5*1024*1024
      redirect_to root_path, :alert => "Size exceeded limit"
      return
    end

    # TODO: handle error for parts above

    file_name = Time.now.to_i.to_s + "_" + uploaded_io.original_filename # Attach the timestamp to avoid overwriting old files
    file_path = Rails.public_path.join("uploads", file_name)
    puts file_path
    count = 0
    data = String::new;
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read) # whole file
    end

    File.open(file_path).readlines.each do |line|
      count += 1
      if (count <= 101)
        data += line
      end
    end

    @csv_for_share = CsvForShare.create(
      :download_link => file_path.to_s,
      :num_lines => count,
      :file_size => number_to_human_size(File.size(file_path)),
      :data => data,
      :link_id => Digest::MD5.hexdigest(data+Time.now.to_i.to_s),
      :original_file_name => uploaded_io.original_filename
    )

    if @csv_for_share.save
      redirect_to show_csv_path(@csv_for_share.link_id, @csv_for_share.original_file_name)
    else
      redirect_to root_path, :alert => "File info is failed to save"
    end
  end

  def show
    @paste = CsvForShare.find_by_link_id(params[:link_id])
    @data_array = CSV.new(@paste.data).to_a
  end

end

