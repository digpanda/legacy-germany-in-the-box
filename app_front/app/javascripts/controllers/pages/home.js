/**
 * Apply Wirecard Class
 */
var Home = {

  /**
   * Initializer
   */
  init: function() {

    $('#js-slider').show();
    
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

  },

}

module.exports = Home;