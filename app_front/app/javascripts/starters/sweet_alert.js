/**
 * SweetAlert Class
 */
var SweetAlert = {

    /**
     * Initializer
     */
    init: function() {

      this.startAlert();

    },

    /**
     *
     */
    startAlert: function() {

      $('.js-alert').click(function(e) {

        e.preventDefault();
        self = this;

        swal({
          title: $(self).data('title') || "Are you sure ?",
          text: $(self).data('text') || "This action cannot be undone.",
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes, delete it!",
          closeOnConfirm: false
        }, function(){
          swal({
            title: "Processing!",
            text: "Your request is being processed ...",
            type: "success",
            showConfirmButton: false
          });
          window.location.href = $(self).attr('href');
        });

      })

    },

}

module.exports = SweetAlert;
