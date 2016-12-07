/**
 * LinkBehaviour Class
 */
var LinkBehaviour = {

    /**
     * Initializer
     */
    init: function() {

      this.setupSubmitForm();

    },

    /**
     * If we use the data-submit-form it will force submit with a simple link
     */
    setupSubmitForm: function() {

      $(document).on('click', '[data-form="submit"]', function(e) {
        e.preventDefault();
        $(this).closest('form').submit()
      });

    },

}

module.exports = LinkBehaviour;
