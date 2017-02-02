Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))

require File.join(Rails.root, 'app', 'services', 'sku_cloner')
