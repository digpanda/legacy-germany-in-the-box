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
      wx.onMenuShareTimeline({
          desc: 'Description example TIMELINE',
          imgUrl: 'https://germanyinbox.com/images/logos/germany-in-the-box.svg',
          link: 'https://germanyinbox.com/guest/links/598de4607302fc46b5032df1/weixin?reference_id=00000',
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
