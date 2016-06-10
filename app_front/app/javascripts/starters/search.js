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

      $(document).on('submit', '#search-form' ,function(e){

        let search = $('#search').val();

        /**
         * If the research is empty it doesn't trigger the submit
         */
        if (!search.trim()) {
          return false;
        } else {
          return true;
        }

      });

    },

}

module.exports = Search;