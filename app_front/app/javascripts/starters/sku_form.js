/**
 * SkuForm Class
 * TODO : this classe should be moved over to the sku area only
 * it's not a starter or anything like that, spreading prop changes
 * on the global system is not safe.
 */
var SkuForm = {

    elements: {
      form: '#sku_form',
      checkbox: '#sku_unlimited',
      input: '#sku_quantity'
    },

    /**
     * Initializer
     */
    init: function() {

      this.setupLimitSystem();

    },

    /**
     * If we are on the correct page containing `js-sku-form`
     * We setup the limit display and activate the checkbox click listener
     * @return {void}
     */
    setupLimitSystem: function() {

      if ($("#js-sku-form").length == 0) {
        return;
      }

      SkuForm.resetLimitDisplay();

      $(SkuForm.elements.checkbox).on('click', function() {
        SkuForm.resetLimitDisplay();
      });

    },

    /**
     * Reset the limit display
     * It will show or hide the input
     * @return {void}
     */
    resetLimitDisplay: function() {
      if ($(SkuForm.elements.checkbox).is(":checked")) {
        SkuForm.switchOffLimit();
        return;
      }
      SkuForm.switchOnLimit();
    },

    /**
     * We disable the limit input and make it unlimited
     * @return {void}
     */
    switchOffLimit: function() {
      $(SkuForm.elements.form).find(SkuForm.elements.input).val('0').prop('disabled', 'true').parent().hide();
    },

    /**
     * We activate the limit input and make it limited
     * @return {void}
     */
    switchOnLimit: function() {
      $(SkuForm.elements.form).find(SkuForm.elements.input).removeAttr('disabled').parent().show();
    }

}

module.exports = SkuForm;
