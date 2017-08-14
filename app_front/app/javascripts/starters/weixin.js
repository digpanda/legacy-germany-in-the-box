/**
 * WeixinStarter Class
 */
var WeixinStarter = {

    /**
     * Initializer
     */
    init: function() {

      this.configure();
      this.onReady();
      this.onError();

    },

    data: function() {
      return $('#weixin').data();
    },

    configure: function() {

      wx.config({
          debug: this.data().debug,
          appId: this.data().appId,
          timestamp: this.data().timestamp,
          nonceStr: this.data().nonceStr,
          signature: this.data().signature,
          jsApiList: this.data().jsApiList
      });

    },

    onReady: function() {

      wx.ready(function(){
        console.log('ready');
      });

    },

    onError: function() {

      wx.error(function(res){
        console.log('error ' + res);
      });

    },

}

module.exports = WeixinStarter;
