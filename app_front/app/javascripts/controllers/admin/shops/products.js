/**
 * Products Class
 */
var Products = {

    /**
     * Initializer
     */
    init: function() {

      this.handleDutyCategoryChange();

    },

    /**
     * We check if the duty category exists through AJAX
     * and throw it / an error on the display
     * @return {void}
     */
    handleDutyCategoryChange: function() {

      var DutyCategory = require("javascripts/models/duty_category");

      $('#duty-category').on('keyup', function(e) {

        let dutyCategoryId = $(this).val();
        DutyCategory.find(dutyCategoryId, function(res) {

          if (res.success) {

            Products.showDutyCategory(res.datas.duty_category);

          } else {

            Products.throwNotFoundDutyCategory();

          }

        });

      });

    },

    showDutyCategory: function(duty_category) {

      $('.js-duty-category').html('<span class="+blue">'+duty_category.name+'</span>');

    },

    throwNotFoundDutyCategory: function() {

      $('.js-duty-category').html('<span class="+red">Duty Category not found</span>');

    },

}

module.exports = Products;
