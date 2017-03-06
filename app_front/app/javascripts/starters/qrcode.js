/**
 * QrCode Class
 */
var QrCode = {

    initialized: false,

    /**
     * Initializer
     */
    init: function() {

      $(window).on('resize', _.debounce($.proxy(this.onResize, this), 300)).trigger('resize');

    },

    onResize: function(e) {

      if (this.isMobile() && this.initialized) {
        this.destroy();
        return;
      }

      if (this.isMobile()) {
        return;
      }

      if (!this.initialized) {
        this.setupWechat();
        this.setupWeibo();
        this.initialized = true;
        return;
      }

    },

    isMobile: function() {
      /**
       * NOTE : this 994 matches with the breakpoint of `=breakpoint` in SASS
       * Please be careful and change the one in the SASS as well
       */
      return $(window).width() <= 994;
    },

    destroy: function() {
      $('#weibo-qr-code-trigger').off('mouseover').off('mouseout');
      $('#wechat-qr-code-trigger').off('mouseover').off('mouseout');
      $('#wechat-qr-code').addClass('hidden');
      $('#weibo-qr-code').addClass('hidden');
      QrCode.initialized = false;
    },

    setupWechat: function() {

      $('#wechat-qr-code-trigger').on('mouseover', function(e) {
        $('#wechat-qr-code').removeClass('hidden');
      });

      $('#wechat-qr-code-trigger').on('mouseout', function(e) {
        $('#wechat-qr-code').addClass('hidden');
      });

      $('#wechat-qr-code-trigger').on('click', function(e) {
        if ($('#wechat-qr-code').hasClass('hidden')) {
            $('#wechat-qr-code').removeClass('hidden');
        } else {
            $('#wechat-qr-code').addClass('hidden');
        }
      });

    },

    setupWeibo: function() {

      $('#weibo-qr-code-trigger').on('mouseover', function(e) {
        $('#weibo-qr-code').removeClass('hidden');
      });

      $('#weibo-qr-code-trigger').on('mouseout', function(e) {
        $('#weibo-qr-code').addClass('hidden');
      });

      $('#weibo-qr-code-trigger').on('click', function(e) {
        if ($('#weibo-qr-code').hasClass('hidden')) {
            $('#weibo-qr-code').removeClass('hidden');
        } else {
            $('#weibo-qr-code').addClass('hidden');
        }
      });

    },


}

module.exports = QrCode;
