require 'fileutils'

module BorderGuruFtp
  module Makers
    class Store < Base

      attr_reader :csv_orders

      def initialize(orders, csv_orders)
        super
        @csv_orders = csv_orders
      end

      def to_local
        raise BorderGuruFtp::Error, "No order to place." if orders.empty?
        prepare_directories
        write_csv_orders
      end

      private

      def prepare_directories
        FileUtils.mkdir_p(local_directory)
        FileUtils.mkdir_p(shop_directory)
      end

      def write_csv_orders
        file = File.open(csv_file_with_path, "w")
        file.write(csv_orders)
      rescue IOError
        raise BorderGuruFtp::Error => "Impossible to write to file"
      ensure
        file.close unless file.nil?
      end

      def shop_directory
        "#{local_directory}#{shop.id}"
      end

      def csv_file_with_path
        "#{shop_directory}/#{formatted_date}_#{border_guru_merchant_id}.csv"
      end

      def formatted_date
        Time.now.strftime("%Y%m%d")
      end

      def local_directory
        @local_directory ||= Rails.root.join(chomped_local_directory)
      end

      def chomped_local_directory
        CONFIG[:ftp][:local_directory].reverse.chomp("/").reverse
      end

    end
  end
end