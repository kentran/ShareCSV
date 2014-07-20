class PastesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :set_format

  def set_format
    request.format = 'html'
  end

  def index

  end

  def create
    upload_io = params[:file]
    csv_filename = upload_io.original_filename

    if upload_io.nil?
      redirect_to root_path, :alert => "File failed to upload"
      return
    elsif !File.extname(csv_filename).eql? ".csv"
      redirect_to root_path, :alert => "Wrong file fo1rmat"
      return
    elsif upload_io.size > 5*1024*1024
      redirect_to root_path, :alert => "Size exceeded limit"
      return
    end

    slug = generate_slug_for(csv_filename)

    # Meta-data
    temp_filepath = upload_io.path
    count, sample_data = extract_sample_and_count(temp_filepath)

    # upload to S3
    upload_to_s3(slug, csv_filename, temp_filepath)

    paste = Paste.create(
      slug: slug,
      file_name: csv_filename,
      num_lines: count,
      file_size: File.size(temp_filepath),
      sample_data: sample_data,
      download_url: http_s3_url_for(slug, csv_filename),
    )

    if paste.save
      render json: {
        status: 'success',
        redirect: show_csv_path(paste.slug, paste.file_name)
      }
    else
      render json: {
        status: 'error',
        error: 'File info is failed is save'
      }
    end
  end

  def generate_slug_for(data)
    Digest::MD5.hexdigest(data[0..100] + Time.now.to_i.to_s)
  end

  def show
    require 'csv'
    @paste = Paste.find_by_slug(params[:slug])
    @data_array = CSV.new(@paste.sample_data).to_a
  end


  def download
    paste = Paste.find_by_slug(params[:slug])
    redirect_to paste.download_url
  end

  private

  def http_s3_url_for(slug, filename)
    "https://s3.amazonaws.com/csvpastebin/uploads/#{slug}/#{filename}"
  end

  def upload_to_s3(slug, original_filename, temp_filepath)
    s3_key = "uploads/#{slug}/#{original_filename}"
    s3object = AWS::S3.new.buckets['csvpastebin'].objects[s3_key]
    s3object.write(file: temp_filepath, content_type: 'text/csv')
  end

  def extract_sample_and_count(file_path)
    count = 0
    data = ''

    num_lines = `wc -l < #{file_path}`.strip.to_i

    file = File.open(file_path)
    while line = file.readline
      count += 1
      if count > 101
        break
      end
      data += line
    end

    return num_lines, data
  end


end

