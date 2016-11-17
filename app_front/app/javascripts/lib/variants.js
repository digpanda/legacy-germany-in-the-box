/**
 * Variants Class
 */
var Variants = {

  setup: function() {

    this.addOptionHandler();
    this.removeOptionHandler();

    this.addVariantHandler();
    this.removeVariantHandler();

  },

  addVariantHandler: function() {

    $('#add-variant').on('click', function(e) {

      e.preventDefault();
      let target = $('.js-temporary-variant.hidden:first');
      console.log(target);
      target.removeClass('hidden');

    })

  },

  removeVariantHandler: function() {

    $('.js-remove-variant').on('click', function(e) {

      e.preventDefault();
      let container = $(this).closest('.js-temporary-variant');
      let input_target = container.find('input');
      input_target.val('');
      container.addClass('hidden');

    });

  },

  /**
   * We add an option (aka suboption in some cases) to the variant
   * It will just show a field which was previously hidden
   * NOTE : everything is managed by rails itself beforehand
   * to make it flexible in the front-end side
   */
  addOptionHandler: function() {

    $('.js-add-option').on('click', function(e) {

      e.preventDefault();
      let target = $(this).closest('.variant-box').find('.js-temporary-option.hidden:first');
      target.removeClass('hidden');

    })

  },

  /**
   * Set the value of the field to empty
   * and hide it from the display
   */
  removeOptionHandler: function() {

    $('.js-remove-option').on('click', function(e) {

      e.preventDefault();
      let container = $(this).closest('.js-temporary-option');
      let input_target = container.find('input');
      input_target.val('');
      container.addClass('hidden');

    });

  }

}

module.exports = Variants;
