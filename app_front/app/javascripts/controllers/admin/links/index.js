/**
* LinksIndex Class
*/
var LinksIndex = {

  /**
  * Initializer
  */
  init: function() {

    this.handleWechatUrl();

  },

  handleWechatUrl: function() {
    $('#wechat-url-adjuster').on('keyup', function(e) {
      let rawUrl = $(this).val();
      LinksIndex.getWechatUrl(rawUrl);
    })
  },

  getWechatUrl: function(url) {

    var Link = require("javascripts/models/link");
    Link.wechat(url, function(res) {

      if (res.success == true) {
        let endUrl = res.data.adjusted_url;
        $('#wechat-url-adjuster-result').val(endUrl);
      }

    });

  },

}

module.exports = LinksIndex;
