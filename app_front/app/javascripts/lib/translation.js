/**
 * Translation Class
 */
 var Translation = {

   find: function(translationSlug, translationScope) {

     var selector = ".js-translation[data-slug='"+translationSlug+"'][data-scope='"+translationScope+"']";
     if ($(selector).length > 0) {
       return $(selector).data('content');
     } else {
       console.error("Translation not found : `"+translationScope+"`.`"+translationSlug+"`");
       return '';
     }

   },

   /**
   * Find a translation and return the string from AJAX with callbacks
   */
   findAsync: function(translationSlug, translationScope, callback) {

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
