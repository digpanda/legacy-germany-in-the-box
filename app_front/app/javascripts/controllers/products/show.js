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

  },

  handleQuantityChange: function() {

    $('#quantity-minus').on('click', function(e) {
      e.preventDefault();
      let quantity = $('#quantity').val();
      if (quantity > 1) {
        quantity--;
      }
      $('#quantity').val(quantity);
    })

    $('#quantity-plus').on('click', function(e) {
      e.preventDefault();
      let quantity = $('#quantity').val();
      if (quantity < $('#quantity').data('max')) {
        quantity++;
      }
      $('#quantity').val(quantity);
    })

  },

  handleProductGalery: function() {

    /**
     * Homemade Gallery System by Laurent
     */
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

  manageClickableImages: function() {

    if ($('#gallery a').size() <= 1) {
      $('#gallery a:first').hide();
    }

  },

  changeMainImage: function(image, loader_selector) {

    $('#main_image').attr('src', image).load(function() {
      $(loader_selector).hide();
      $(this).show();
    }).before(function() {
      $(loader_selector).show();
      $(this).hide();
    });

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

    $('#product_price_with_currency_yuan').html(skuDatas['price_with_currency_yuan']);
    $('#product_price_with_currency_euro').html(skuDatas['price_with_currency_euro']);
    $('#quantity-left').html(skuDatas['quantity']);

    if (skuDatas['discount'] == 0) {

      ProductsShow.skuHideDiscount();

    } else {

      ProductsShow.skuShowDiscount();

      $('#product_discount_with_currency_euro').html(skuDatas['price_before_discount_in_euro']);
      $('#product_discount_with_currency_yuan').html('<span class="+barred"></span>'+skuDatas['price_before_discount_in_yuan']);
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

    for (let i = 0; i < images.length; i++) {

      let image = images[i];

      if ($('#thumbnail-'+i).length > 0) {
        $('#thumbnail-'+i).html('<a href="#" data-image="'+image.fullsize+'" data-zoom-image="'+image.zoomin+'"><div class="product-page__thumbnail-image" style="background-image:url('+image.thumb+');"></div></a>');
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
