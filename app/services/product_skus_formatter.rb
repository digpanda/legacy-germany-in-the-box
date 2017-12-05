require 'csv'

# generate format for products skus
# TODO : those CSV libraries are all very similar and
# could be definitely refactored better
class ProductSkusFormatter < BaseService
  include Rails.application.routes.url_helpers

  CSV_LINE_CURRENCY = 'EUR'
  MAX_DESCRIPTION_CHARACTERS = 200
  HEADERS = [
    'Product ID',
    'Product Name (zh-CN)',
    'Product Name (de)',
    'Product Brand',
    'Product Status',
    'Product Approved',
    'Product Duty Category',
    'Product HS Code',
    'Product Highlight',
    'Sku ID',
    'Sku Price (EUR)',
    'Sku price estimated taxes (EUR)',
    'Sku price with taxes (EUR)',
    'Sku Quantity',
    'Sku Unlimited',
    'Sku Weight',
    'Sku Status',
    'Sku Discount',
    'Sku Space Length',
    'Sku Space Width',
    'Sku Space Height',
    'Sku Volume', # volume
    'Sku Country of Origin',
    'Created At',
    'Updated At',
  ]

  attr_reader :products

  def initialize(products)
    @products = products
  end

  # convert a list of products (model) into a normalized CSV file
  def to_csv
    CSV.generate do |csv|
      csv << HEADERS
      products.each do |product|
        product.skus.each do |sku|
          csv << csv_line(product, sku)
        end
      end
    end
  end

  private

    def csv_line(product, sku)
      [
        product.id,
        product.name_translations[:'zh-CN'],
        product.name_translations[:de],
        product.brand&.name,
        product.status,
        product.approved,
        "#{product.duty_category&.code}",
        product.hs_code,
        product.highlight,
        sku.id,
        sku.price,
        sku.taxes_per_unit,
        sku.price_with_taxes,
        sku.quantity,
        sku.unlimited,
        sku.weight,
        sku.status,
        sku.discount,
        sku.space_length,
        sku.space_width,
        sku.space_height,
        sku.volume,
        sku.country_of_origin,
        sku.c_at,
        sku.u_at
      ]
    end
end
