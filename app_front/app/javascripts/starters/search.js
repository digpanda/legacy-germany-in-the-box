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

      $('.js-search-button i').on('click', function(e) {
        e.preventDefault(); // prevent go back to the header
        Search.showSearchForm();
        $('.js-search-input').focus();
      });

      $('.js-search-input').on('focusout', function(e) {
          Search.hideSearchForm();
      });

    },

    showSearchForm: function() {
      $('.js-search-button').addClass('+hidden');
      $('.js-search-form').removeClass('+hidden');
    },

    hideSearchForm: function() {
      $('.js-search-button').removeClass('+hidden');
      $('.js-search-form').addClass('+hidden');
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
