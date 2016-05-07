module.exports = {
  paths: {
    public: '../app/assets',
    watched: ['app/javascripts', 'app/stylesheets', 'app/images']
  },
  files: {
    javascripts: {
      joinTo: {
        'javascripts/app.js': /^app/,
        'javascripts/vendor.js': /^(bower_components|vendor)/
      }
    },
    stylesheets: {
      joinTo: {
        'stylesheets/app.css': /^app\/stylesheets\/main.sass/
      }
    }
  },

  plugins: {
    babel: {presets: ['es2015']}
  }

};

/*
        //'stylesheets/vendor.css': /^(bower_components|vendor)/
 */
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