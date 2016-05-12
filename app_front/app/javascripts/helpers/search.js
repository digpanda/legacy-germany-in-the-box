/**
 * Search Class
 */
var Search = {

    /**
     * Initializer
     */
    init: function() {

      this.searchable_input();

    },

    /**
     * We make the input searchable on click
     */
    searchable_input: function() {

      var self = this;

      $("#js-search-click").on("click", function() {
        self.show_searcher();
      });

      $(document).click(function() {
        self.show_clicker();
      });

      $("#js-search-input").click(function(e) {
        e.stopPropagation(); 
      });
      
      $("#js-search-click").click(function(e) {
        e.stopPropagation();
      });

    },

    show_clicker: function() {

      $("#js-search-input").hide();
      $("#js-search-click").show();

    },

    show_searcher: function() {

      $("#js-search-click").hide();
      $("#js-search-input").show();
      $("#js-search-input #search").focus();

    }

}

module.exports = Search;