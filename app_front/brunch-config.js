module.exports = {
  paths: {
    public: '../app/assets',
    watched: ['app/javascripts', 'app/stylesheets', 'app/images']
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