/**
 * ProductLightbox Class
 */
var ProductLightbox = {

    /**
     * Initializer
     */
    init: function() {

      this.selectVariantOptionLoader();

    },

    /**
     * When in the lightbox if the customer change the variant option
     * It will reload everything through AJAX
     */
    selectVariantOptionLoader: function() {

      if ($('select.variant-option').length > 0) {

        $('select.variant-option').change(function () {

          console.log('changed');

          var product_id = $(this).attr('product_id');

          console.log(product_id);
          var option_ids = [];

          $('ul.product-page-meta-info [id^="product_' + product_id + '_variant"]').each ( function(o) {
            option_ids.push($(this).val())
          });

          $.ajax({
            dataType: 'json',
            data: { option_ids: this.value.split(',') },
            url: '/products/' + product_id + '/get_sku_for_options',
            success: function(json){
              var qc = $('#product_quantity_' + product_id).empty();

              for (let i=1; i <= parseInt(json['quantity']); ++i) {
                qc.append('<option value="' + i + '">' + i + '</option>')
              }

              $('#product_price_' + product_id).text(json['price'] + ' ' +  json['currency']);
              $('#product_discount_' + product_id).text(json['discount'] + ' ' +  '%');
              $('#product_saving_' + product_id).text(parseFloat(json['price']) * parseInt(json['discount'])/100  + ' ' +  json['currency']);
              $('#product_inventory_' + product_id).text(json['quantity'])

              var fotorama = $('#product_quick_view_dialog_' + product_id).find('.fotorama').fotorama().data('fotorama');
              fotorama.load([{img: json['img0_url']}, {img: json['img1_url']}, {img: json['img2_url']}, {img: json['img3_url']}])
            }
          });
        
        });

      }

    },
    

}

module.exports = ProductLightbox;