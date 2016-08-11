/**
 * Translation Class
 */
 var Translation = {

   /**
   * Find a translation and return the string
   */
   find: function(translationSlug, translationScope, callback) {

     var TranslationModel = require("javascripts/models/translation");

     TranslationModel.show(translationSlug, translationScope, function(res) {

       if (res.success === false) {

         console.error("Translation not found `"+translationSlug+"` ("+res.error+")");

       } else {

        callback(res.translation);

       }

     });
   },

 }

module.exports = Translation;
