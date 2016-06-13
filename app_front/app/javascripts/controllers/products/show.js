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

  },

  handleProductGalery: function() {

    $(document).on('click', '#gallery a', function(e) {

      console.log('click trigerring');

      let image = $(this).data('image');
      let zoomImage = $(this).data('zoom-image');

      /**
       * Homemade Gallery System by Laurent
       */
      e.preventDefault();

      // Changing the image when we click on any thumbnail of the #gallery
      $('#main_image').attr('src', image);

      $('#main_image').magnify({
        speed: 0,
        src: zoomImage,
      });


    });

    // We don't forget to trigger the click to load the first image
    $('#gallery a:first').trigger('click');

  },

  handleSkuChange: function() {

    $('select#option_ids').change(function () {

      var product_id = $(this).attr('product_id');
      var option_ids = [];

      $('ul.product-page-meta-info [id^="product_' + product_id + '_variant"]').each ( function(o) {
        option_ids.push($(this).val())
      });

      $.ajax({

        dataType: 'json',
        data: { option_ids: this.value.split(',') },
        url: '/api/guest/products/' + product_id + '/show_sku',
        success: function(json){
          var qc = $('#product_quantity_' + product_id).empty();

          for (let i=1; i <= parseInt(json['quantity']); ++i) {
            qc.append('<option value="' + i + '">' + i + '</option>')
          }

          $('#product_price_with_currency_yuan').html(json['price_with_currency_yuan']);
          $('#product_price_with_currency_euro').html(json['price_with_currency_euro']);
          $('#quantity-left').html(json['quantity']);

          let images = json['images'];
            
          for (let i = 0; i < images.length; i++) { 

            let image = images[i];

            if ($('#thumbnail-'+i).length > 0) {
              $('#thumbnail-'+i).html('<a href="#" data-image="'+image.fullsize+'" data-zoom-image="'+image.zoomin+'"><img src="'+image.thumb+'" width="100px"></a>');
            }

          }

          ProductsShow.handleProductGalery();

        }

      });

    });

  },

}

module.exports = ProductsShow;
