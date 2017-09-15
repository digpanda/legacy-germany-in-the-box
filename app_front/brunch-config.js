module.exports = {
  paths: {
    public: '../public',
    watched: ['app/javascripts', 'app/stylesheets', 'app']
  },

  files: {

    javascripts: {
      joinTo: {
        'javascripts/vendor.js': /^bower_components/,
        // 'javascripts/vendor-node.js': /^node_modules/,
        'javascripts/app.js': /^app/
      },
    },

    stylesheets: {
      joinTo: {
        'stylesheets/shared.css': /^app\/stylesheets\/shared.sass/,
        'stylesheets/customer.css': /^app\/stylesheets\/customer.sass/,
        'stylesheets/shopkeeper.css': /^app\/stylesheets\/shopkeeper.sass/,
        'stylesheets/admin.css': /^app\/stylesheets\/admin.sass/,
        'stylesheets/vendor.css': /^bower_components/
      }
    }

  },

  plugins: {
    babel: { presets: ['es2015'] },
    sass: { mode: 'native' }
  }

}
