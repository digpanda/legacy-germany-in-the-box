/**
 * ProductsList Class
 */
var SkuForm = { // CURRENTLY NOT IN USED IN THE SYSTEM

    /**
     * Initializer
     */
    init: function() {

      this.turnUnlimit();

    },

    turnUnlimit: function() {

        if ($("#js-sku-form").length > 0) {
            $('input[id^=product_skus_attributes_][id$=_unlimited]').change(
                function () {
                    if ( $(this).is(":checked") ) {
                        $('input[id^=product_skus_attributes_][id$=quantity]').val(0).prop('disabled', 'true')
                    } else {
                        $('input[id^=product_skus_attributes_][id$=quantity]').removeAttr('disabled')
                    }
                }
            )
        }

    },

}

module.exports = SkuForm;