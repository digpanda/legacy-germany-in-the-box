/**
* ChineseInput Class
*/
var ChineseInput = {

  // chinese_regex: /[\u4E00-\u9FFF\u3400-\u4DFF\uF900-\uFAFF]+/g,

  /**
  * Initializer
  */
  init: function() {

    this.restrictToChinese();

  },

  restrictToChinese: function() {

    $("input").on('invalid', function (e) {
      if (typeof $(this).data('error') != "undefined") {
        this.setCustomValidity($(this).data('error'));
      }
    });

    $("input").on('keyup', function(e) {
      this.setCustomValidity("");
    });

    // THIS IS CURRENTLY NOT IN USE
//
//     $(".js-only-chinese").ready(function(e) {
//
//       console.log('fuck this');
//       $(this).attr('oninvalid', "setCustomValidity('Debe completar este campo.');");
//       $(this).attr('pattern', "/[\u4E00-\u9FFF\u3400-\u4DFF\uF900-\uFAFF]+/g")
//
// // :pattern => "/[\u4E00-\u9FFF\u3400-\u4DFF\uF900-\uFAFF]+/g", :oninvalid => "setCustomValidity('Should not be left empty.')"
//
//
//     });

    // $(".js-only-chinese").keypress(function(e) {
    //
    //   let key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
    //   var regex = new RegExp(ChineseInput.chinese_regex);
    //   if (!regex.test(key)) {
    //      e.preventDefault();
    //      return false;
    //   }
    //
    // });

  },


}

module.exports = ChineseInput;
