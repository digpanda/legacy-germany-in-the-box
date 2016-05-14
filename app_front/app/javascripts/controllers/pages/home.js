/**
 * Apply Wirecard Class
 */
var Home = {

  /**
   * Initializer
   */
  init: function() {

    $('#js-slider').lightSlider({
      "item": 1,
      "loop": true,
      "slideMargin": 0,
      "pager": false,
      "auto": true,
      "pause": "3000",
      "speed": "1000",
      "adaptiveHeight": true,
      "verticalHeight": 1000,
      "mode": "fade",
      "enableDrag": false,
      "enableTouch": true
    });

    $.widget( 'custom.catcomplete', $.ui.autocomplete, {
      _create: function() {
        this._super();
        this.widget().menu( 'option', 'items', '> :not(.ui-autocomplete-category)' );
      },
      _renderMenu: function( ul, items ) {
        var that = this,
        search_category = '';
        $.each( items, function( index, item ) {
          var li;
          if ( item.sc != search_category ) {
            ul.append( "<li class='ui-autocomplete-category'>" + item.sc + '</li>' );
            search_category = item.sc;
          }
          li = that._renderItemData( ul, item );
          if ( item.sc ) {
            li.attr( 'aria-label', item.sc + ' : ' + item.label );
          }
        });
      }
    });

    $( '#products_search_keyword' ).catcomplete({
      delay: 1000,
      source: '/products/autocomplete_product_name',
      select: function (a, b) {
        $(this).val(b.item.value);
        $('#search_products_form').submit()
      }
    });

    $( 'select.variant-option' ).change(function () {
      product_id = $(this).attr('product_id');
      option_ids = [];

      $('ul.product-page-meta-info [id^="product_' + product_id + '_variant"]').each ( function(o) {
        option_ids.push($(this).val())
      });

      $.ajax({
        dataType: 'json',
        data: { option_ids: this.value.split(',') },
        url: '/products/' + product_id + '/get_sku_for_options',
        success: function(json){
          qc = $('#product_quantity_' + product_id).empty();

          for (i=1; i <= parseInt(json['quantity']); ++i) {
            qc.append('<option value="' + i + '">' + i + '</option>')
          }

          $('#product_price_' + product_id).text(json['price'] + ' ' +  json['currency']);
          $('#product_discount_' + product_id).text(json['discount'] + ' ' +  '%');
          $('#product_saving_' + product_id).text(parseFloat(json['price']) * parseInt(json['discount'])/100  + ' ' +  json['currency']);
          $('#product_inventory_' + product_id).text(json['quantity'])

          fotorama = $('#product_quick_view_dialog_' + product_id).find('.fotorama').fotorama().data('fotorama');
          fotorama.load([{img: json['img0_url']}, {img: json['img1_url']}, {img: json['img2_url']}, {img: json['img3_url']}])
        }
      });
    });

  },

}

module.exports = Home;