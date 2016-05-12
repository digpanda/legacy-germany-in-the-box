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

      $("#js-search-click").on("click", function() {
        $(this).hide();
        $("#js-search-input").show();
        $("#js-search-input #search").focus();
      });

      $(document).click(function() {
         $("#js-search-input").hide();
         $("#js-search-click").show();
      });

      $("#js-search-input").click(function(e) {
          e.stopPropagation(); 
          return false;
      });
      
      $("#js-search-click").click(function(e) {
          e.stopPropagation(); 
          return false;
      });

    },

}

module.exports = Search;