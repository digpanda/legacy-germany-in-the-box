var Translation = require('javascripts/lib/translation');
var Product = require("javascripts/models/product");
var Messages = require("javascripts/lib/messages");

/**
 * ProductFavorite Class
 */
var ProductFavorite = {

    /**
     * Initializer
     */
    init: function() {

      this.setupHeartClick();

    },

    /**
     * manage the heart click events
     * @return {void}
     */
    setupHeartClick: function() {
      this.heartElement().on('click', $.proxy(this.onHeartClick, this));
    },

    /**
     * Main button for the favorite system
     * @return {element}
     */
    heartElement: function() {
      return $('.js-heart-click')
    },

    /**
     * returns the productId of the product on the page@
     * @return {element}
     */
    productId: function() {
      return this.heartElement().attr('data-product-id')
    },

    /**
     * Is the product in favorite or not ?
     * @return {boolean}
     */
    isFavorite: function() {
      return this.heartElement().attr('data-favorite') == '1'
    },

    /**
     * When the heart is clicked
     */
    onHeartClick: function(e) {

      e.preventDefault();

      if (this.isFavorite()) {
        this.removeFavorite();
      } else {
        this.addFavorite();
      }

    },

    /**
     * We unlike from the model and display the unlike
     * @return {void}
     */
    removeFavorite: function() {

      this.displayUnlike();
      this.modelUnlike($.proxy(this.updateTotalFavorites, this))

    },

    /**
     * We like from the model and display the like (heart)
     * @return {void}
     */
    addFavorite: function() {

      this.displayLike();
      this.modelLike($.proxy(this.updateTotalFavorites, this))

    },

    /**
     * Update the favorites count on the display
     * @param  {Function} res
     * @return {void}
     */
    updateTotalFavorites: function(res) {
      let favoritesCount = res.favorites.length;
      $('#total-likes').html(favoritesCount);
    },

    /**
     * Like the model and manage errors on the display
     * @param  {Function} callback
     * @return {Function}
     */
    modelLike: function(callback) {
      Product.like(this.productId(), this.handleModelResponse(callback));
    },

    /**
     * Unlike the model and manage errors on the display
     * @param  {Function} callback
     * @return {Function}
     */
    modelUnlike: function(callback) {
      Product.unlike(this.productId(), this.handleModelResponse(callback));
    },

    /**
     * Handle the model response if he likes or unlike
     * @param  {Function} callback
     * @return {Function}
     */
    handleModelResponse: function(callback) {
      return function(response) {

        if (res.success === false) {
          Messages.makeError(res.error);
        } else {
          callback(response);
        }

      }
    },

    /**
     * Change the elements so they look unliked
     * @return {void}
     */
    displayUnlike: function() {
      this.heartElement().find('i').addClass('+grey').removeClass('+pink');
      this.heartElement().attr('data-favorite', '0');
      this.heartElement().find('span').html(Translation.find('add', 'favorites'))
    },

    /**
     * Change the elements so they look liked
     * @return {void}
     */
    displayLike: function(el) {
      this.heartElement().find('i').addClass('+pink').removeClass('+grey');
      this.heartElement().attr('data-favorite', '1');
      this.heartElement().find('span').html(Translation.find('remove', 'favorites'))
    },

}

module.exports = ProductFavorite;
