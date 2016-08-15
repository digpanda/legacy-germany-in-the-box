Rails.configuration.login_failure_limit = 3
Rails.configuration.app_cache_expire_limit = Rails.env.production? ? 1.hours : 10.minutes
Rails.configuration.max_num_addresses = 3
Rails.configuration.max_num_shop_billing_addresses = 1
Rails.configuration.max_num_shop_sender_addresses = 1
Rails.configuration.max_num_tags = 3
Rails.configuration.max_num_target_groups = 6
Rails.configuration.max_num_sales_channels = 12
Rails.configuration.max_num_variants = 3
Rails.configuration.max_customer_collections = 10
Rails.configuration.max_shopkeeper_collections = 100
Rails.configuration.limit_for_users_search = 20
Rails.configuration.limit_for_products_search = 20
Rails.configuration.limit_for_collections_search = 20
Rails.configuration.limit_for_popular_products = 20
Rails.configuration.max_magic_number = 11
Rails.configuration.max_add_to_cart_each_time = 5
Rails.configuration.default_customer_locale = 'zh-CN'
Rails.configuration.default_shopkeeper_locale = 'de'
Rails.configuration.max_tiny_text_length = 64
Rails.configuration.max_short_text_length = 256
Rails.configuration.max_medium_text_length = 1000
Rails.configuration.max_long_text_length = 2500
Rails.configuration.max_additional_text_length = 10000
Rails.configuration.min_password_length = 8

Rails.cache.clear
