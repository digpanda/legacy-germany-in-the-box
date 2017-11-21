/**
 * Form Class
 */
var Form = {

    /**
     * CamelCase to underscored case
     */
    forceValidatorOnHiddenFields: function() {
     $.fn.validator.Constructor.INPUT_SELECTOR = ':input:not([type="submit"], button):enabled';
    },


}

module.exports = Form;
