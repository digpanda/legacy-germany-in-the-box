module.exports = {
  paths: {
    public: '../public',
    watched: ['app/javascripts', 'app/stylesheets', 'app']
  },

  files: {

    javascripts: {
      joinTo: {
        'javascripts/app.js': /^app/,
        'javascripts/vendor.js': /^bower_components/
      }
    },

    stylesheets: {
      joinTo: {
        'stylesheets/app.css': /^app\/stylesheets\/main.sass/,
        'stylesheets/vendor.css': /^bower_components/
      }
    }

  },

  plugins: {
    babel: {presets: ['es2015']},
    sass: { mode: 'native' }
  }

}