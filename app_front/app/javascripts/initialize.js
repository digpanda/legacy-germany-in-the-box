document.addEventListener('DOMContentLoaded', () => {

  /**
   * Controllers loader by Loschcode
   * Damn simple class loader.
   */
  let routes = $("#js-routes").data();
  
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
