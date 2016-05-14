/**
 * Footer Class
 */
var Footer = {

    /**
     * Initializer
     */
    init: function() {

      console.log('yes');
      this.stickyFooter();

    },

    /**
     * Put the footer on the bottom of the page
     */
    stickyFooter: function() {

      self = this;

      if ($('.js-footer-stick').length > 0) {

        this.processStickyFooter();
        
        $(window).resize(function() {

          self.processStickyFooter();
          
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
