import VueClipboard from 'vue-clipboard2';

/**
 * WeixinStarter Class
 */
var WeixinStarter = {

    clipboardVue: null,
    setupClipboardVue: function() {

      Vue.use(VueClipboard);
      
    },

    /**
     * Initializer
     */
    init: function() {
      this.setupClipboardVue();
    },

}

module.exports = WeixinStarter;
