/**
 * Translations Class
 */
var Translations = {

  /**
   * Get the Translations details
   */
  show: function(translationSlug, translationScope, callback) {

      $.ajax({

        method: "GET",
        url: '/api/guest/translations/0',
        data: {translation_slug: translationSlug, translation_scope: translationScope}

      }).done(function(res) {

        callback(res);

      }).error(function(err) {

        if (typeof err == "undefined") {
          return;
        }
        
        callback({success: false, error: err.responseJSON.error});

      });

  },

}

module.exports = Translations;
