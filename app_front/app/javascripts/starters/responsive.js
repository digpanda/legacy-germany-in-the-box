/**
 * Responsive Class
 */
var Responsive = { // CURRENTLY NOT IN USED IN THE SYSTEM

    /**
     * Initializer
     */
    init: function() {

      this.manageCategoriesMenu();

    },

    manageCategoriesMenu: function() {

      $('#categories-menu').slicknav({

        "prependTo": ".mobile-category-menu" //".container-fluid"

      });

    },

}

module.exports = Responsive;