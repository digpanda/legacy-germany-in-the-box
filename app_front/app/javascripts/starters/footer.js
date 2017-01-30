/**
 * Footer Class
 */
var Footer = {

    /**
     * Initializer
     */
    init: function() {

      this.stickyFooter();

    },

    /**
     * Put the footer on the bottom of the page
     */
    stickyFooter: function() {

      var self = this;

      if ($('.js-footer-stick').length > 0) {

        Footer.processStickyFooter();

        $(document).on('message:hidden', function() {
          Footer.processStickyFooter();
        });

        $(window).resize(function() {
          Footer.processStickyFooter();
        });

      }

    },

    processStickyFooter: function() {

      var docHeight, footerHeight, footerTop;

      $('.js-footer-stick').css('margin-top', 0);

      var docHeight = $(window).height();
      var footerHeight = $('.js-footer-stick').height();
      var headerHeight = $('.navbar-fixed-top').first().height();
      var footerTop = $('.js-footer-stick').position().top + footerHeight;

      if (footerTop < docHeight) {
        console.log('processing');
        console.log(headerHeight);
        $('.js-footer-stick').css('margin-top', (docHeight + (headerHeight * 1.30) - footerTop) + 'px');
      }

    },

}

module.exports = Footer;
