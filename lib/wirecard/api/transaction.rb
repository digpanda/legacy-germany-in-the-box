require 'net/http'

module Wirecard
  class Api
    class Transaction

      attr_reader :merchant_id, :transaction_id

      def initialize(merchant_id, transaction_id)
        @merchant_id = merchant_id
        @transaction_id = transaction_id # "af3864e1-0b2b-11e6-9e82-00163e64ea9f"
      end

      def retrieve
        @retrieve ||= Request.new(query).response
      end

      def query
        "merchants/#{merchant_id}/payments/#{transaction_id}"
      end

      def status
        return :corrupted unless retrieve&.[](:payment)&.[](:"transaction-state")
        case retrieve[:payment][:"transaction-state"]
          when "success"
            :success
          when "in-progress"
            :in_progress
          when "failed"
            :failed
          else
            :corrupted
        end
      end

    end
  end
end
