# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( bootstrap-multiselect.js bootstrap-multiselect.css bootstrap-datepicker/core.js bootstrap-datepicker/locales/bootstrap-datepicker.zh-CN.js bootstrap-datepicker/locales/bootstrap-datepicker.de.js bootstrap-datepicker.css china_city.js achat.js achat.css leftmenu/* couponia/* jquery.js jquery_ujs.js jquery-ui/widget.js jquery-ui/autocomplete.js validator.js bootstrapValidator.min.css)
