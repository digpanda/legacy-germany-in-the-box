/**
 * Search Class
 */
var Search = {

    /**
     * Initializer
     */
    init: function() {

      this.categoryFilter();
      this.searchInput();

    },

    /**
     * We make the search behavior
     */
    searchInput: function() {

      $('#search-button').on('click', function(e) {
        Search.showSearchForm();
        $('#search-input').focus();
      });

      $('#search-input').on('focusout', function(e) {
          Search.hideSearchForm();
      });

    },

    showSearchForm: function() {
      $('#search-button').addClass('+hidden');
      $('#search-form').removeClass('+hidden');
    },

    hideSearchForm: function() {
      $('#search-button').removeClass('+hidden');
      $('#search-form').addClass('+hidden');
    },

    /**
     * We make the category filter auto-trigger
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
