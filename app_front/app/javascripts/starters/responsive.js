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

      var Translation = require('javascripts/lib/translation');

      $('#categories-menu').slicknav({

        "prependTo": ".mobile-category-menu", //".container-fluid"
        "label": Translation.find('menu', 'button'),
        "closeOnClick": true

      });

      // We hook the slicknav menu with some HTML content
      // It will occur after the menu is ready.
      // To stay clean it takes an invisible element within the HTML
      let left_side_content = $('#categories-menu-left-side').html();
      $('.slicknav_menu').prepend(left_side_content);

    },

}

module.exports = Responsive;
