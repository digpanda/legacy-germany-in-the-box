require 'json'

Rails.configuration.login_failure_limit = 3
Rails.configuration.autocomplete_limit = 20
Rails.configuration.product_search_cache_expire_limit = 24.hours
Rails.configuration.max_num_addresses = 3

Rails.cache.clear


