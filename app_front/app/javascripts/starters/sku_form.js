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
            let component = $('input[id^=product_skus_attributes_][id$=_unlimited]')

            if ( component.is(":checked") ) {
                $('input[id^=product_skus_attributes_][id$=quantity]').val(0).prop('disabled', 'true').parent().hide();
            }

            component.change(
                function () {
                    if ( $(this).is(":checked") ) {
                        $('input[id^=product_skus_attributes_][id$=quantity]').val(0).prop('disabled', 'true').parent().hide();
                    } else {
                        $('input[id^=product_skus_attributes_][id$=quantity]').val('').removeAttr('disabled').parent().show()
                    }
                }
            )
        }

    },

}

module.exports = SkuForm;