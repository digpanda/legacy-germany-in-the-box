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
        this.onMenuShareAppMessage();

      }

    },

    data: function() {
      return $('#weixin').data();
    },

    configure: function() {
      console.log({
          debug: this.data().debug,
          appId: this.data().appId,
          timestamp: this.data().timestamp,
          nonceStr: this.data().nonceStr,
          signature: this.data().signature,
          jsApiList: this.data().jsApiList
      });
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
        console.log('WEIXIN READY');
      });
    },

    onError: function() {
      wx.error(function(res){
        console.log('WEIXIN ERROR : ' + res.errMsg);
      });
    },

    onMenuShareTimeline: function() {
      wx.onMenuShareTimeline({
          title: 'Example title TIMELINE',
          link: 'https://germanyinbox.com/test',
          imgUrl: 'https://germanyinbox.com/images/logos/germany-in-the-box.svg',

          success: function () {
            console.log('SUCCESS TIMELINE SHARE')
          },
          cancel: function () {
            console.log('CANCEL TIMELINE SHARE');
          }
      });
    },

    onMenuShareAppMessage: function() {
      wx.onMenuShareAppMessage({
          title: 'Example title APP MESSAGE',
          desc: 'This is a description',
          link: 'https://germanyinbox.com/test',
          imgUrl: 'https://germanyinbox.com/images/logos/germany-in-the-box.svg',
          type: 'link',
          dataUrl: '',

          success: function () {
            console.log('SUCCESS MESSAGE SHARE')
          },
          cancel: function () {
            console.log('CANCEL MESSAGE SHARE')
          }
      });
    },

}

module.exports = WeixinStarter;
