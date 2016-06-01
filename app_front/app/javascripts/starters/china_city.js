/**
 * ChinaCity Class
 */
var ChinaCity = {

    /**
     * Initializer
     */
    init: function() {

      this.startChinaCity();

    },

    /**
     * 
     */
    startChinaCity: function() {

      $.fn.china_city = function () {
          return this.each(function () {
              var selects;
              selects = $(this).find('.city-select');
              return selects.change(function () {
                  var $this, next_selects;
                  $this = $(this);
                  next_selects = selects.slice(selects.index(this) + 1);
                  $("option:gt(0)", next_selects).remove();
                  if (next_selects.first()[0] && $this.val() && !$this.val().match(/--.*--/)) {
                      return $.get("/china_city/" + ($(this).val()), function (data) {
                          var i, len, option;
                          if (data.data != null) {
                              data = data.data;
                          }
                          for (i = 0, len = data.length; i < len; i++) {
                              option = data[i];
                              next_selects.first()[0].options.add(new Option(option[0], option[1]));
                          }
                          return next_selects.trigger('china_city:load_data_completed');
                      });
                  }
              });
          });
      };

      $(document).ready( function () {
          $('.city-group').china_city();
      })

    },

}

module.exports = ChinaCity;
