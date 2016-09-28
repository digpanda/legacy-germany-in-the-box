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

      docHeight = $(window).height();
      footerHeight = $('.js-footer-stick').height();
      footerTop = $('.js-footer-stick').position().top + footerHeight;

      if (footerTop < docHeight) {
        $('.js-footer-stick').css('margin-top', 10 + (docHeight - footerTop) + 'px');
      }

    },

}

module.exports = Footer;
