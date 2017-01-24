/**
 * Search Class
 */
var Search = {

    /**
     * Initializer
     */
    init: function() {

      this.categoryFilter();

    },

    /**
     * We make the input searchable on click
     */
    categoryFilter: function() {

      $('.js-category-filter').on('change', function(e) {

        let category_id = $(this).val();

        var UrlProcess = require('javascripts/lib/url_process');
        UrlProcess.insertParam('category_id', category_id);
        
      });

    },

}

module.exports = Search;
