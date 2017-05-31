var Translation = require("javascripts/lib/translation");
/**
 * ProductsShow Class
 */
var ProductsShow = {

  /**
   * Initializer
   */
  init: function() {

    this.handleProductGalery();
    this.handleSkuChange();
    this.handleQuantityChange();
    this.handleAddSku();

  },

  /**
   * Grow or reduce price on the display
   * @param  {String} [option] `grow` or `reduce` price
   * @param  {Integer} old_quantity    the original old quantity
   * @param  {String} selector        the area the HTML had to be changed
   * @return {void}
   */
  changePrice: function(option='grow', old_quantity, selector) {

    if (typeof $(selector) == 'undefined') {
      return;
    }

    old_quantity = parseInt(old_quantity);
    let old_price = $(selector).html();
    let unit_price = parseFloat(old_price) / parseInt(old_quantity);

    if (option == 'grow') {
      var new_quantity = old_quantity+1;
    } else if (option == 'reduce') {
      var new_quantity = old_quantity-1;
    }

    let new_price = unit_price * new_quantity;
    $(selector).html(new_price.toFixed(2));

  },

  /**
   * Handle the quantity change with different selector (minus or plus)
   * @return {void}
   */
  handleQuantityChange: function() {

    this.manageQuantityMinus();
    this.manageQuantityPlus();

  },

  /**
   * Reduce the quantity by clicking on the minus symbol on the page
   * @return {void}
   */
  manageQuantityMinus: function() {

    $('#quantity-minus').on('click', function(e) {

      e.preventDefault();
      let quantity = $('#quantity').val();;

      if (quantity > 1) {

        ProductsShow.changePrice('reduce', quantity, '#product_discount_with_currency_yuan .amount');
        ProductsShow.changePrice('reduce', quantity, '#product_discount_with_currency_euro .amount');

        // We show per unit
        //ProductsShow.changePrice('reduce', quantity, '#product_fees_with_currency_yuan .amount');

        ProductsShow.changePrice('reduce', quantity, '#product_price_with_currency_yuan .amount');
        ProductsShow.changePrice('reduce', quantity, '#product_price_with_currency_euro .amount');
        quantity--;

      }
      $('#quantity').val(quantity);
    })

  },

  /**
   * Grow the quantity by clicking on the plus symbol on the page
   * @return {void}
   */
  manageQuantityPlus: function() {

    $('#quantity-plus').on('click', function(e) {

      e.preventDefault();
      let quantity = $('#quantity').val();

      if (quantity < $('#quantity').data('max')) {

        ProductsShow.changePrice('grow', quantity, '#product_discount_with_currency_yuan .amount');
        ProductsShow.changePrice('grow', quantity, '#product_discount_with_currency_euro .amount');

        // We show per unit only because it's not growable accurately
        //ProductsShow.changePrice('grow', quantity, '#product_fees_with_currency_yuan .amount');
        ProductsShow.changePrice('grow', quantity, '#product_price_with_currency_yuan .amount');
        ProductsShow.changePrice('grow', quantity, '#product_price_with_currency_euro .amount');
        quantity++;

      }
      $('#quantity').val(quantity);
    })

  },

  /**
   * Adds the product to the cart when clicking on 'Add Product'
   * @return {void}
   */

  handleAddSku: function () {

      $('#js-add-to-cart').on('click', function (e) {

          e.preventDefault();

          var OrderItem = require("javascripts/models/order_item");

          let quantity = $('#quantity').val();
          let skuId = $('#sku_id').val();
          let productId = $('#sku_id').data('productId');

          OrderItem.addSku(productId, skuId, quantity, function(res) {

              var Messages = require("javascripts/lib/messages");

              if (res.success === true) {

                  Messages.makeSuccess(res.message);

                  var refreshTotalProducts = require('javascripts/services/refresh_total_products');
                  refreshTotalProducts.perform();

              } else {

                  Messages.makeError(res.error)

              }
          });

      })

  },

  /**
   * Manage the whole gallery selection
   * @return {void}
   */
  handleProductGalery: function() {

    $(document).on('click', '#gallery a', function(e) {

      let image = $(this).data('image');
      let zoomImage = $(this).data('zoom-image');

      e.preventDefault();

      // Changing the image when we click on any thumbnail of the #gallery
      // We also manage a small pre-loader in case it's slow.
      ProductsShow.changeMainImage(image, '.js-loader');

      /*
      $('#main_image').magnify({
        speed: 0,
        src: zoomImage,
      });*/

    });

    // We don't forget to trigger the click to load the first image
    $('#gallery a:first').trigger('click');

    // We hide the button because
    // if there's only one element
    ProductsShow.manageClickableImages();

  },

  /**
   * Hide the thumbnail clickables images of the gallery
   * If not needed (such as one image total)
   * @return {void}
   */
  manageClickableImages: function() {

    if ($('#gallery a').size() <= 1) {
      $('#gallery a:first').hide();
    }

  },

  /**
   * Load a new main image from a thumbanil
   * @param  {String} image new image source
   * @param  {String} loader_selector loader to display
   * @return {void}
   */
  changeMainImage: function(image, loader_selector) {

    var ContentPreloader = require("javascripts/lib/content_preloader");
    ContentPreloader.process($('#main_image').attr('src', image), loader_selector);

  },

  /**
   * When the customer change of sku selection, it refreshes some datas (e.g. price)
   */
  handleSkuChange: function() {

    $('select#option_ids').change(function() {

      var productId = $(this).attr('product_id');
      var optionIds = $(this).val().split(',');

      var ProductSku = require("javascripts/models/product_sku");
      var Messages = require("javascripts/lib/messages");

      ProductSku.show(productId, optionIds, function(res) {

        if (res.success === false) {

          Messages.makeError(res.error);

        } else {

          ProductsShow.skuChangeDisplay(productId, res);

        }

      });

    });

  },

  skuHideDiscount: function() {

    $('#product_discount_with_currency_euro').hide();
    $('#product_discount_with_currency_yuan').hide();
    $('#product_discount').hide();

    $('#product_discount').removeClass('+discount');

  },

  skuShowDiscount: function() {

    $('#product_discount_with_currency_euro').show();
    $('#product_discount_with_currency_yuan').show();
    $('#product_discount').show();

    $('#product_discount').addClass('+discount');

  },

  /**
   * Change the display of the product page sku datas
   */
  skuChangeDisplay: function(productId, skuDatas) {

    ProductsShow.refreshSkuQuantitySelect(productId, skuDatas['quantity']); // productId is useless with the new system (should be refactored)

    $('#product_fees_with_currency_yuan').html(skuDatas['fees_with_currency_yuan']);
    $('#product_price_with_currency_yuan').html(skuDatas['price_with_currency_yuan']);
    $('#product_price_with_currency_euro').html(skuDatas['price_with_currency_euro']);
    $('#quantity-left').html(skuDatas['quantity']);

    $('#quantity').val(1); // we reset the quantity to 1

    if (skuDatas['discount'] == 0) {

      ProductsShow.skuHideDiscount();

    } else {

      ProductsShow.skuShowDiscount();

      $('#product_discount_with_currency_euro').html('<span class="+barred"><span class="+dark-grey">'+skuDatas['price_before_discount_in_euro']+'</span></span>');
      $('#product_discount_with_currency_yuan').html('<span class="+barred"><span class="+black">'+skuDatas['price_before_discount_in_yuan']+'</span></span>');
      $('#product_discount').html(skuDatas['discount_with_percent']+'<br/>');

    }


    ProductsShow.refreshSkuSecondDescription(skuDatas['data_format']);

    ProductsShow.refreshSkuAttachment(skuDatas['data_format'], skuDatas['file_attachment']);
    ProductsShow.refreshSkuThumbnailImages(skuDatas['images']);

    ProductsShow.handleProductGalery();

  },

  /**
   * Refresh sku quantity select (quantity dropdown)
   */
  refreshSkuQuantitySelect: function(productId, quantity) {

    var quantity_select = $('#product_quantity_' + productId).empty();

    for (let i=1; i <= parseInt(quantity); ++i) {
      quantity_select.append('<option value="' + i + '">' + i + '</option>')
    }

  },

  /**
   * Refresh sku thumbnail images list
   */
  refreshSkuThumbnailImages: function(images) {

      $('#gallery').empty();
    for (let i = 0; i < images.length; i++) {

      let image = images[i];

      // protection to avoid empty images
      // in case of transfer bug to the front-end
      if (image.fullsize != null) {

          $('#gallery').append(
              '<div id="thumbnail-' + i + '" class="col-md-2 col-xs-4 +centered">' +
              '<a href="#" data-image="'+image.fullsize+'" data-zoom-image="'+image.zoomin+'"><div class="product-page__thumbnail-image" style="background-image:url('+image.thumb+');"></div></a>' +
              '</div>'
          );

      }

    }

  },

  /**
   * Refresh the sku second description
   */
  refreshSkuSecondDescription: function(secondDescription) {

    var more = "<h3>"+Translation.find('more', 'title')+"</h3>";

    if (typeof secondDescription !== "undefined") {
      $('#product-file-attachment-and-data').html(more+secondDescription);
    } else {
      $('#product-file-attachment-and-data').html('');
    }

  },

  /**
   * Refresh the sku attachment (depending on second description too)
   */
  refreshSkuAttachment: function(secondDescription, attachment) {

    var more = "<h3>"+Translation.find('more', 'title')+"</h3>";

    if (typeof attachment !== "undefined") {
      if (typeof secondDescription !== "undefined") {
        $('#product-file-attachment-and-data').html(more+secondDescription);
      }
      $('#product-file-attachment-and-data').append('<br /><a class="btn btn-default" target="_blank" href="'+attachment+'">PDF Documentation</a>');
    }

  },

}

module.exports = ProductsShow;
