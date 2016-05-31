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

      $("search-form").submit(function(e) {

        e.preventDefault();
        console.log('yes it clicked');
        
      });

    },

}

module.exports = Search;