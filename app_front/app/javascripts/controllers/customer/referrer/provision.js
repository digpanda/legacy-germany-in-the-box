/**
 * Provision class
 */
var Provision = {

  /**
   * Initializer
   */
  init: function() {

    this.handleDetailTables();

  },

  handleDetailTables: function() {
    $('#click-detail-tables').on('click', this.clickDetailTables);
  },

  clickDetailTables: function(e) {
    e.preventDefault();
    $('#detail-tables').show();
    $('#click-detail-tables').hide();
  }

}

module.exports = Provision;
