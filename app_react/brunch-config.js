// // See http://brunch.io for documentation.
// exports.files = {
//   javascripts: {
//     joinTo: {
//       'vendor.js': /^(?!app)/,
//       'app.js': /^app/
//     }
//   },
//   stylesheets: {joinTo: 'app.css'}
// };
//
// exports.plugins = {
//   babel: {presets: ['latest', 'react']}
// };
//
//
// ///////
// //////

module.exports = {
  paths: {
    public: '../public',
    watched: ['app/components', 'app/styles', 'app']
  },

  files: {

    javascripts: {
      joinTo: {
        'javascripts/app_react.js': /^app/,
        'javascripts/vendor_react.js': /^node_modules/
      }
    },

    stylesheets: {
      joinTo: {
        'stylesheets/react.css': /^app\/styles\/application.sass/,
      }
    }

  },

  plugins: {
    babel: {presets: ['latest', 'react']},
    sass: { mode: 'native' }
  }

}
