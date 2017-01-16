/**
 * QrCode Class
 */
var QrCode = { // CURRENTLY NOT IN USED IN THE SYSTEM

    /**
     * Initializer
     */
    init: function() {

      this.manageWechatQrCode();
      this.manageWeiboQrCode();

    },

    manageWechatQrCode: function() {

      $('#wechat-qr-code-trigger').on('mouseover', function(e) {
        $('#wechat-qr-code').removeClass('hidden');
      })

      $('#wechat-qr-code-trigger').on('mouseout', function(e) {
        $('#wechat-qr-code').addClass('hidden');
      })

    },

    manageWeiboQrCode: function() {

      $('#weibo-qr-code-trigger').on('mouseover', function(e) {
        $('#weibo-qr-code').removeClass('hidden');
      })

      $('#weibo-qr-code-trigger').on('mouseout', function(e) {
        $('#weibo-qr-code').addClass('hidden');
      })

    },

}

module.exports = QrCode;
