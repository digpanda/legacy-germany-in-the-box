/**
 * PostForm System
 * by Laurent Schaffner
 */
var PostForm = (function($) {

  return {

    /**
     * Initializer
     */
    init: function() {

    },

    /**
     * Generate and create a form
     */
    send: function(params, path, target, method) {

      method = method || "POST";
      path = path || "";
      target = target || "";

      var form = document.createElement("form");
      form.setAttribute("method", method);
      form.setAttribute("action", path);
      form.setAttribute("target", target); 

      for (var key in params) {

        if (params.hasOwnProperty(key))  {

          var f = document.createElement("input");
          f.setAttribute("type", "hidden");
          f.setAttribute("name", key);
          f.setAttribute("value", params[key]);
          form.appendChild(f);

        }

      }

      document.body.appendChild(form); // <- JS way
      // $('body').append(form); // <- jQuery way
      
      form.submit();

    } 

  };

})(jQuery);

/**
 * jQuery scope and such
 */
(function ($) {

  $(document).ready(function() {

    PostForm.init($);

  });

})(jQuery, PostForm);