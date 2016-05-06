document.addEventListener('DOMContentLoaded', () => {

  /**
   * Controllers loader by Loschcode
   * Very small and easy system.
   */
  let routes = $("#js-routes").data();
  
  try {

    let obj = require("javascripts/controllers/"+routes.controller+"/"+routes.action);
    obj.init();

  } catch(err) {

    console.log("Unable to initialize #js-routes `"+routes.controller+"`.`"+routes.action+"`");
  
  }


});
