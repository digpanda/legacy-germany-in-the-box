$(document).ready(() => {

  /**
   * Controllers loader by Loschcode
   * Damn simple class loader.
   */
  let routes = $("#js-routes").data();
  let starters = require("javascripts/starters");

  try {

    var Casing = require("javascripts/lib/casing");

    for (var idx in starters) {

      console.warn('Loading starter : ' + starters[idx]);

      let formatted_starter = Casing.underscoreCase(starters[idx]).replace('-', '_');
      let obj = require("javascripts/starters/"+formatted_starter);
      obj.init();

    }

  } catch(err) {

    console.error("Unable to initialize #js-starters");
    return;

  }
 
  try {

    var obj = require("javascripts/controllers/"+routes.controller+"/"+routes.action);

  } catch(err) {

    console.error("Unable to initialize #js-routes `"+routes.controller+"`.`"+routes.action+"`");
    return;

  }

  /**
   * Initialization
   */
  obj.init();

});
