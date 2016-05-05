module.exports = {
  paths: {
    public: '../app/assets'
  },
  files: {
    javascripts: {
      joinTo: {
        'javascripts/vendor.js': /^(?!app)/,
        'javascripts/app.js': /^app/
      }
    },
    stylesheets: {
      joinTo: 'stylesheets/app.css'
    }
  },

  plugins: {
    babel: {presets: ['es2015']}
  }

};

/*
exports.config =
  paths: 
    public: '../public'
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(bower_components|vendor)/
    stylesheets:
      joinTo:
        'stylesheets/vendor.css': /^(bower_components|vendor)/
        'stylesheets/front.css': /^app\/styles\/front/
        'stylesheets/profile.css': /^app\/styles\/profile/
        'stylesheets/admin.css': /^app\/styles\/admin/

    templates:
      joinTo: 'javascripts/app.js'

  plugins:
    sass:
      mode: 'ruby'
*/