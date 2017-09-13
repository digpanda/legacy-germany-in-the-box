import VueClipboard from 'vue-clipboard2';

/**
 * WeixinStarter Class
 * BIG NOTE : this system is the first we use with VueJS
 * it needs a lot of refactoring as it mixes up the Weixin system, with a clipboard system, with a Sharing system
 * which should be split into differente files.
 */
var WeixinStarter = {

    weixinVue: null,
    setupWeixinVue: function() {

      this.vueTooltipDirective();

      Vue.use(VueClipboard);

      this.weixinVue = new Vue({
        el: '#weixin-vue',
        data: {
          shared: false,
          loaded: false,
          copied: null
        },
        watch: {
          shared: (shared) => {
            if (shared === true) {
              window.location.href = WeixinStarter.shareLinkData().back;
            }
          },
          loaded: (loaded) =>  {
            if (loaded === true) {
            }
          }
        },
        methods: {
          copySuccess() {
            this.copied = true
          },
          copyFail() {
            this.copied = false
          }
        },
      });
    },

    vueTooltipDirective: () => {
      Vue.directive('tooltip', {
        bind: (el) => {
          WeixinStarter.clickTooltip(el)
        }
      })
    },

    clickTooltip: (el) => {
      $(el).on('click', (e) => {
        console.log('yo');
        e.preventDefault();
      })
      $(el).tooltipster({
        animation: 'fade',
        delay: 200,
        trigger: 'click',
        maxWidth: 350,
        timer: 1000
      })
    },

    /**
     * Initializer
     */
    init: function() {

      if ($('#weixin-vue').length > 0) {
        this.setupWeixinVue();
      }

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
        WeixinStarter.weixinVue.loaded = true;
        WeixinStarter.resetWeixinCache();
        // WeixinStarter.checkJsApi();
        WeixinStarter.onMenuShareTimeline();
        WeixinStarter.onMenuShareAppMessage();

      });
    },

    resetWeixinCache: function() {
      // NOTE : not working system
      // let needRefresh = sessionStorage.getItem("need-refresh");
      // if(needRefresh){
      //   sessionStorage.removeItem("need-refresh");
      //   location.reload();
      // } else {
      //   sessionStorage.setItem("need-refresh", true);
      // }
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
          WeixinStarter.weixinVue.shared = true;
        },
        cancel: function () {
        }
      }
    },

}

module.exports = WeixinStarter;
