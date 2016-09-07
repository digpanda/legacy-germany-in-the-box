module BorderGuruEmail
  class TransmitOrders
    class Dispatch < Base

      CSV_ENCODE = "UTF-8"
      MEAN_OF_TRANSPORT = "Pakete"
      DESTINATION = "FRA" # Frankfurt

      # dispatch into emails via our mailer
      # including datas and a csv file
      def to_email
        if orders.any? # could have no orders ?
          HermesMailer.notify(shopkeeper.id.to_s, email_datas, csv_file).deliver_now
        end
      end

      private

      def csv_file
        BorderGuruFtp::TransferOrders::Makers::Generate.new(orders).to_csv.encode(CSV_ENCODE)
      end

      def email_datas
        {
          :company_name => shop.name,
          :contact_name => shop.decorate.manager_full_name,
          :contact_phone => shop.tel,
          :number_of_packages => orders.length,
          :total_weight_in_kg => total_weight,
          :mean_of_transport => MEAN_OF_TRANSPORT,
          :number_of_mean_of_transport => orders.length, # alias of number of packages
          :total_volume => total_volume,
          :pickup_address => shop.billing_address.decorate.full_address,
          :destination => DESTINATION,
          :orders_barcodes => barcodes_list,
          :orders_descriptions => clean_descriptions_list
        }
      end

      # everything below could be put into the model directly ?
      def total_weight
        orders.reduce(0) { |acc, order| acc + order.decorate.total_weight }
      end

      def total_volume
        orders.reduce(0) { |acc, order| acc + order.decorate.total_volume }
      end

      def barcodes_list
        orders.reduce([]) { |acc, order| acc << order.border_guru_shipment_id }
      end

      def clean_descriptions_list
        orders.reduce([]) { |acc, order| acc << order.decorate.clean_order_items_description }
      end

    end
  end
end
