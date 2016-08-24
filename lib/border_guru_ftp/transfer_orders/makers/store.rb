require 'fileutils'

# store the orders into our local directories.
# `orders` must be previously ordered by `shop` since the @shop data
# is taken and memoized on initialization
# use #to_local to store them
module BorderGuruFtp
  class TransferOrders
    module Makers
      class Store < Base

        attr_reader :orders_csv

        def initialize(orders, orders_csv)
          super
          @orders_csv = orders_csv
        end

        # prepare the directories for the order throwing
        # then store the CSV files in local directories
        def to_local
          raise BorderGuruFtp::Error, "No order to place." if orders.empty?
          prepare_directories
          write_orders_csv
        end

        private

        def prepare_directories
          FileUtils.mkdir_p(BorderGuruFtp.local_directory)
          FileUtils.mkdir_p(shop_directory)
        end

        def write_orders_csv
          file = File.open(csv_file_with_path, "w")
          file.write(orders_csv)
        rescue IOError
          raise BorderGuruFtp::Error => "Impossible to write to local file"
        ensure
          file.close unless file.nil?
        end

        def shop_directory
          "#{BorderGuruFtp.local_directory}#{shop.id}"
        end

        def csv_file_with_path
          if Rails.env.production?
            "#{shop_directory}/#{formatted_date}_#{border_guru_merchant_id}.csv"
          else
            "#{shop_directory}/#{formatted_date}_#{border_guru_merchant_id}_TEST.csv"
          end
        end

        def formatted_date
          @formatted_date ||= Time.now.strftime("%Y%m%d")
        end
      end
    end
  end
end
