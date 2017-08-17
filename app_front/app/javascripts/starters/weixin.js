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
          desc: 'Description example TIMELINE',
          imgUrl: 'https://germanyinbox.com/images/logos/germany-in-the-box.svg',
          link: 'https://germanyinbox.com/test',
          title: 'Example title TIMELINE',

          success: function () {
            alert('SUCCESS TIMELINE SHARE')
          },
          cancel: function () {
            alert('CANCEL TIMELINE SHARE');
          }
      });
    },

    onMenuShareAppMessage: function() {
      wx.onMenuShareAppMessage({
          desc: 'This is a description',
          imgUrl: 'https://germanyinbox.com/images/logos/germany-in-the-box.svg',
          link: 'https://germanyinbox.com/test',
          title: 'Example title APP MESSAGE',

          success: function () {
            alert('SUCCESS MESSAGE SHARE')
          },
          cancel: function () {
            alert('CANCEL MESSAGE SHARE')
          }
      });
    },

}

module.exports = WeixinStarter;
