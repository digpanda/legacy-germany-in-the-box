Turnout.configure do |config|
  #config.app_root = '.'
  #config.named_maintenance_file_paths = {default: config.app_root.join('tmp', 'maintenance.yml').to_s}
  #config.default_maintenance_page = Turnout::MaintenancePage::HTML
  #config.maintenance_pages_path = config.app_root.join('public').to_s
  config.default_reason = "The site is temporarily down for maintenance.\nPlease check back soon. klm"
  config.default_response_code = 503

end