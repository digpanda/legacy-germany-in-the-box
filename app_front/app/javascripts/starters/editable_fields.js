/**
* EditableFields Class
* Will make the edit fields appear and the text disappear
* It's used in the order edit for admin (for example)
* This is a very small system, not ambitious at all
* Keep it this way or use a real plugin.
*/
var EditableFields = {

  /**
  * Initializer
  */
  init: function() {

    this.hideAllEditable();
    $('.js-editable-click').on('click', $.proxy(this.manageShowEditable, this));

  },

  manageShowEditable: function(e) {
    e.preventDefault();
    this.showEditable(e.currentTarget);
  },

  hideAllEditable: function() {
    $('.js-editable-text').show();
    $('.js-editable-field').hide();
    $('.js-editable-click').show();
    $('.js-editable-submit').hide();
  },

  hideEditable: function(element) {
    $(element).parent().find('.js-editable-text').show();
    $(element).parent().find('.js-editable-field').hide();
    $(element).parent().find('.js-editable-click').show();
    $(element).parent().find('.js-editable-submit').hide();
  },

  showEditable: function(element) {
    $(element).parent().find('.js-editable-text').hide();
    $(element).parent().find('.js-editable-field').show();
    $(element).parent().find('.js-editable-click').hide();
    $(element).parent().find('.js-editable-submit').show();
  },

}

module.exports = EditableFields;
