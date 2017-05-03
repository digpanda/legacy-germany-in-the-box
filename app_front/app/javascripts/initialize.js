$(document).ready(() => {

  /**
   * Controllers loader by Loschcode
   * Damn simple class loader.
   */
  let routes = $("#js-routes").data();
  let info = $("#js-info").data();
  let starters = require("javascripts/starters");

  /**
   * Disable console.log for production and tests (poltergeist)
   */
   if ((info.environment == "production") || (info.environment == "test")) { // || (info.environment == "test")
     if (typeof(window.console) != "undefined") {
       window.console = {};
       window.console.log = function () {};
       window.console.info = function () {};
       window.console.warn = function () {};
       window.console.error = function () {};
     }
   }

  try {

    var Casing = require("javascripts/lib/casing");

    for (var idx in starters) {

      if (info.environment != "test") {
        console.info('Loading starter : ' + starters[idx]);
      }

      let formatted_starter = Casing.underscoreCase(starters[idx]).replace('-', '_');
      let obj = require("javascripts/starters/"+formatted_starter);
      obj.init();

    }

  } catch(err) {

    console.error("Unable to initialize #js-starters ("+err+")");
    return;

  }

  try {
    var meta_obj = require("javascripts/controllers/"+routes.controller);
    console.info("Loading controller "+routes.controller);
    meta_obj.init();
  } catch(err) {
    console.warn("Unable to initialize #js-routes `"+routes.controller+"` ("+err+")");
  }

  try {
    var obj = require("javascripts/controllers/"+routes.controller+"/"+routes.action);
    console.info("Loading controller-action "+routes.controller+"/"+routes.action);
  } catch(err) {
    console.warn("Unable to initialize #js-routes `"+routes.controller+"`.`"+routes.action+"` ("+err+")");
    return;
  }

  /**
   * Initialization
   */
  obj.init();

});
