/**
* InputValidation Class
*/
var InputValidation = {

  /**
  * Initializer
  */
  init: function() {

    this.restrictToChinese();
    this.addressPidValidation();

  },

  cancelValidation: function(field) {
    return $('form').find(field)
             .prop('required', false)
             .removeData(['bs.validator.errors', 'bs.validator.previous']).end()
             .validator('validate');

  },

  // Depending the country we remove or not the mandatory attribute
  // and then hide the field (Europe / China)
  // NOTE : all those are sensitive since we use the raw selectors generated from Rails
  // If there's any problem about it, check them from the HTML directly and fix it here
  addressPidValidation: function() {
    console.log('refresh validation')
    InputValidation.refreshPidValidation();
    $("input[name='address[country]'").on('click', function(e) {
      console.log('something is happening')
      InputValidation.refreshPidValidation();
    })
  },

  refreshPidValidation() {
    console.log( $('#address_country_europe:checked').val() );
    if ($('#address_country_europe:checked').val()) {
      //this.cancelValidation('#address_pid')
      $('#address_pid').hide();
    } else {
      //this.requireValidation('#address_pid')
      $('#address_pid').show();
    }
  },

  /**
   * USE : just add data-error to an input to have the custom error show up
   */
  restrictToChinese: function() {

    $("input").on('invalid', function (e) {
      if (typeof $(this).data('error') != "undefined") {
        this.setCustomValidity($(this).data('error'));
      }
    });

    $("input").on('keyup', function(e) {
      this.setCustomValidity("");
    });

  },


}

module.exports = InputValidation;
