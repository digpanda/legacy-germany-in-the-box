/**
 * Search Class
 */
var Search = {

    /**
     * Initializer
     */
    init: function() {

      this.searchableInput();

    },

    /**
     * We make the input searchable on click
     */
    searchableInput: function() {

      var self = this;

      $("#js-search-click").on("click", function() {
        self.showSearcher();
      });

      $(document).click(function() {
        self.showClicker();
      });

      $("#js-search-input").click(function(e) {
        e.stopPropagation(); 
      });
      
      $("#js-search-click").click(function(e) {
        e.stopPropagation();
      });

    },

    showClicker: function() {

      $("#js-search-input").hide();
      $("#js-search-click").show();

    },

    showSearcher: function() {

      $("#js-search-click").hide();
      $("#js-search-input").show();
      $("#js-search-input #search").focus();

    }

}

module.exports = Search;