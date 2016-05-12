document.addEventListener('DOMContentLoaded', () => {

  /**
   * Controllers loader by Loschcode
   * Damn simple class loader.
   */
  let routes = $("#js-routes").data();
  let helpers = $("#js-helpers").data();

  try {

    for (var helper in helpers) {

      let obj = require("javascripts/helpers/"+helper);
      obj.init();

    }

  } catch(err) {

    console.log("Unable to initialize #js-helpers");
    return;

  }
  
  try {

    var obj = require("javascripts/controllers/"+routes.controller+"/"+routes.action);

  } catch(err) {

    console.log("Unable to initialize #js-routes `"+routes.controller+"`.`"+routes.action+"`");
    return;

  }

  /**
   * Initialization
   */
  obj.init();

});
