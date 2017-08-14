/**
 * WeixinStarter Class
 */
var WeixinStarter = {

    /**
     * Initializer
     */
    init: function() {

      if (typeof this.data() !== "undefined") {

        this.configure();
        this.onReady();
        this.onError();

        this.onMenuShareTimeline();

      }

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
        alert('WEIXIN ERROR : ' + res);
      });
    },

    onMenuShareTimeline: function() {
      wx.onMenuShareTimeline({
          title: 'Example title',
          link: 'https://germanyinbox.com/test',
          imgUrl: 'https://germanyinbox.com/images/logos/germany-in-the-box.svg',
          success: function () {
            alert('SUCCESS TIMELINE SHARE')
          },
          cancel: function () {
            alert('CANCEL TIMELINE SHARE')
          }
      });
    },

}

module.exports = WeixinStarter;
