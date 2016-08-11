/**
 * ProductForm Class
 */
var ProductForm = {

    /**
     * Initializer
     */
    init: function() {

      this.manageShopkeeperProductForm();

    },

    manageShopkeeperProductForm: function() {

      if ($("#js-product-form").length > 0) {

        var productForm = $("#js-product-form").data();
        var productId = productForm.productId;

        $('select.duty-categories').multiselect({
          nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
          nSelectedText: Translation.find('n_selected_text', 'multiselect'),
          enableFiltering: true,
          enableCaseInsensitiveFiltering: true,
          maxHeight: 400
        }).multiselect();

        $('#edit_product_submit_btn').click( function() {

              $('input.dynamical-required').each(
                function () {
                  if ( $(this).val().length == 0 ) {
                    $(this).addClass('invalidBorderClass');
                  } else {
                    $(this).removeClass('invalidBorderClass');
                  }
                }
              );

              if ( $('.invalidBorderClass').length > 0 ) {
                return false;
              }

            });

            $('a[rel=popover]').popover();

            var panel_cnt = $("#variants_panel_"+productId).children('.panel-body').find('.panel').length
            if (panel_cnt == 0) $("#a_add_variant_"+productId).click();

      }

    }

}

module.exports = ProductForm;
