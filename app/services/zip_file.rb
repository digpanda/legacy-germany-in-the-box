require 'rubygems'
require 'zip'
require 'fileutils'

class ZipFile
  attr_reader :input_dir, :output_file

  # Initialize with the input_dir to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  def perform
    FileUtils.rm(output_file) if File.exist?(output_file)

    Zip::File.open(output_file, Zip::File::CREATE) do |zipfile|
      Dir[File.join(input_dir, '*')].each do |file|
        zipfile.add(file.sub(input_dir, ''), file)
      end
    end
  end

end
