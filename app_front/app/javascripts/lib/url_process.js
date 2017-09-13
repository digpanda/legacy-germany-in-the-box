/**
 * UrlProcess Class
 */
var UrlProcess = {

  urlParam: function(param) {
      var pageUrl = decodeURIComponent(window.location.search.substring(1)),
          sURLVariables = pageUrl.split('&'),
          parameterName,
          i;

      for (i = 0; i < sURLVariables.length; i++) {
          parameterName = sURLVariables[i].split('=');

          if (parameterName[0] === param) {
              return parameterName[1] === undefined ? true : parameterName[1];
          }
      }
  },

  insertParam: function(key, value) {

      key = encodeURI(key); value = encodeURI(value);

      var kvp = document.location.search.substr(1).split('&');

      var i=kvp.length; var x; while(i--)
      {
          x = kvp[i].split('=');

          if (x[0]==key)
          {
              x[1] = value;
              kvp[i] = x.join('=');
              break;
          }
      }

      if(i<0) {kvp[kvp.length] = [key,value].join('=');}

      //this will reload the page, it's likely better to store this until finished
      document.location.search = kvp.join('&');
  }


}

module.exports = UrlProcess;
