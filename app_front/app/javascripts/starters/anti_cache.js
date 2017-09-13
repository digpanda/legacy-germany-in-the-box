var UrlProcess = require('javascripts/lib/url_process');

/**
 * AntiCache Class
 */
var AntiCache = {

    /**
     * Initializer
     */
    init() {

      this.setupAntiCache();

    },

    /**
     * When the param cache=false then we refresh the page with a timer
     * It's a global system throughout all pages
     */
    setupAntiCache() {

      // If the cache is off ; `cache=false` in parameters
      if (this.cacheOff()) {
        // We manage the time if needed
        if (!this.timePresent()) {
          this.insertCurrentTime();
        }
      }
    },


    // This will refresh the page and add time=SOMETIME in the URL
    insertCurrentTime() {
      UrlProcess.insertParam('time', jQuery.now());
    },

    cacheOff() {
      return UrlProcess.urlParam('cache') == "false"
    },

    // Is the time parameter present ?
    timePresent() {
      return typeof UrlProcess.urlParam('time') != "undefined"
    },
}

module.exports = AntiCache;
