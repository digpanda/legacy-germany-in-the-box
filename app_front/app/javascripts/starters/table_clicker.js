/**
 * TableClicker Class
 */
var TableClicker = {

    /**
     * Initializer
     */
    init: function() {

      this.handleTableClicker();

    },

    handleTableClicker: function() {
      $('tr').on('click', TableClicker.onClickTr)
    },

    onClickTr: function(e) {
      let link = $(e.currentTarget).data('href');
      if (typeof link !== "undefined") {
        window.location = link;
      }
    }


}

module.exports = TableClicker;
