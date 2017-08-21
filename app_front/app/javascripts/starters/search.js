/**
 * Search Class
 */
var Search = {

    /**
     * Initializer
     */
    init: function() {

      this.categoryFilter();
      this.brandFilter();
      this.searchInput();
      this.statusFilter();

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

      $('select.js-package-set-brand-filter').on('change', function(e) {

        let brand_id = $(this).val(); // current selected value
        let option = $(this).find("option:selected"); // let's get inside the option itself
        let href = option.data("href"); // get the href if it exists

        if (typeof href !== "undefined") {
          window.location.href = location.protocol + '//' + location.host + href;
        }

      });

    },

    /**
     * We make the category filter auto-trigger
     */
    brandFilter: function() {

      $('.js-category-filter').on('change', function(e) {

        let category_id = $(this).val();

        var UrlProcess = require('javascripts/lib/url_process');
        UrlProcess.insertParam('category_id', category_id);

      });

      $('select.js-package-set-category-filter').on('change', function(e) {

        let category_id = $(this).val(); // current selected value
        let option = $(this).find("option:selected"); // let's get inside the option itself
        let href = option.data("href"); // get the href if it exists

        if (typeof href !== "undefined") {

          window.location.href = location.protocol + '//' + location.host + href;
          // document.location = location.host + href;
        } else {
          // we will refresh the current page the category id
          var UrlProcess = require('javascripts/lib/url_process');
          UrlProcess.insertParam('category_slug', category_id);
        }

      });

    },

    statusFilter: function() {
        $('.js-order-status-filter').on('change', function(e) {

            let status = $(this).val();

            var UrlProcess = require('javascripts/lib/url_process');
            UrlProcess.insertParam('status', status);

        });
    },

}

module.exports = Search;
