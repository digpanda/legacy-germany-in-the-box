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

      EditableFields.hideEditable();

      $('#editable-click').on('click', function() {
        EditableFields.showEditable();
        EditableFields.makeButton();
      })

    },

    hideEditable: function() {
      $('.js-editable').show();
      $('.js-editable-field').hide();
      $('#editable-send').hide();
    },

    showEditable: function() {
      $('.js-editable').hide();
      $('.js-editable-field').show();
      $('#editable-send').show();
    },

    makeButton: function() {
      $('#editable-click').parent().html('<input href="#" id="editable-send" type="submit" value="Update" class="btn btn-primary">');
    }

}

module.exports = EditableFields;
