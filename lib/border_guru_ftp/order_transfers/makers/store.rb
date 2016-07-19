require 'fileutils'

module BorderGuruFtp
  module Makers
    class Store < Base

      attr_reader :orders_csv

      def initialize(orders, orders_csv)
        super
        @orders_csv = orders_csv
      end

      def to_local
        raise BorderGuruFtp::Error, "No order to place." if orders.empty?
        prepare_directories
        write_orders_csv
      end

      private

      def prepare_directories
        FileUtils.mkdir_p(local_directory)
        FileUtils.mkdir_p(shop_directory)
      end

      def write_orders_csv
        file = File.open(csv_file_with_path, "w")
        file.write(orders_csv)
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
        @formatted_date ||= Time.now.strftime("%Y%m%d")
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