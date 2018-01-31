require 'rubygems'
require 'zip'

class ZipFile

  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  def perform
    # Dir["#{TEMPORARY_DIRECTORY}*"]
    Zip::File.open(output_file, Zip::File::CREATE) do |zip|
      Dir["#{TEMPORARY_DIRECTORY}*"].each do |file_to_zip|
        filename = File.basename(file_to_zip)
        zip.add(filename, file_to_zip)
      end
    end
  end

end
