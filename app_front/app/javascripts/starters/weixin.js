/**
 * WeixinStarter Class
 */
var WeixinStarter = {

    /**
     * Initializer
     */
    init: function() {

      if (typeof this.data() !== "undefined") {
        this.config();
        this.onReady();
        this.onError();
      }

    },

    data: function() {
      return $('#weixin').data();
    },

    shareLinkData: function() {
      return $('#weixin-share-link').data();
    },

    config: function() {
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
        console.log('Weixin is ready.');
        WeixinStarter.checkJsApi();
        WeixinStarter.onMenuShareTimeline();
        WeixinStarter.onMenuShareAppMessage();
      });
    },

    onError: function() {
      wx.error(function(res){
        console.log('Weixin received an error : ' + res.errMsg);
      });
    },

    checkJsApi: function() {
      wx.checkJsApi({
          jsApiList: this.data().jsApiList,
          success: function(res) {
            console.log('Check Api : ' + res.checkResult)
          }
      });
    },

    onMenuShareTimeline: function() {
      if (this.shareLinkAvailable()) {
        wx.onMenuShareTimeline(WeixinStarter.shareLinkParams());
      }
    },

    onMenuShareAppMessage: function() {
      if (this.shareLinkAvailable()) {
        wx.onMenuShareAppMessage(WeixinStarter.shareLinkParams());
      }
    },

    shareLinkAvailable: function() {
      return (typeof this.shareLinkData() !== "undefined");
    },

    shareLinkParams: function() {
      return {
        desc: WeixinStarter.shareLinkData().desc,
        imgUrl: WeixinStarter.shareLinkData().imgUrl,
        link: WeixinStarter.shareLinkData().link,
        title: WeixinStarter.shareLinkData().title,

        success: function () {
        },
        cancel: function () {
        }
      }
    },

}

module.exports = WeixinStarter;
