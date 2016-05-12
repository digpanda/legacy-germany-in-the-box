(function() {
  'use strict';

  var globals = typeof window === 'undefined' ? global : window;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};
  var aliases = {};
  var has = ({}).hasOwnProperty;

  var expRe = /^\.\.?(\/|$)/;
  var expand = function(root, name) {
    var results = [], part;
    var parts = (expRe.test(name) ? root + '/' + name : name).split('/');
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function expanded(name) {
      var absolute = expand(dirname(path), name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var hot = null;
    hot = hmr && hmr.createHot(name);
    var module = {id: name, exports: {}, hot: hot};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var expandAlias = function(name) {
    return aliases[name] ? expandAlias(aliases[name]) : name;
  };

  var _resolve = function(name, dep) {
    return expandAlias(expand(dirname(name), dep));
  };

  var require = function(name, loaderPath) {
    if (loaderPath == null) loaderPath = '/';
    var path = expandAlias(name);

    if (has.call(cache, path)) return cache[path].exports;
    if (has.call(modules, path)) return initModule(path, modules[path]);

    throw new Error("Cannot find module '" + name + "' from '" + loaderPath + "'");
  };

  require.alias = function(from, to) {
    aliases[to] = from;
  };

  var extRe = /\.[^.\/]+$/;
  var indexRe = /\/index(\.[^\/]+)?$/;
  var addExtensions = function(bundle) {
    if (extRe.test(bundle)) {
      var alias = bundle.replace(extRe, '');
      if (!has.call(aliases, alias) || aliases[alias].replace(extRe, '') === alias + '/index') {
        aliases[alias] = bundle;
      }
    }

    if (indexRe.test(bundle)) {
      var iAlias = bundle.replace(indexRe, '');
      if (!has.call(aliases, iAlias)) {
        aliases[iAlias] = bundle;
      }
    }
  };

  require.register = require.define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has.call(bundle, key)) {
          require.register(key, bundle[key]);
        }
      }
    } else {
      modules[bundle] = fn;
      delete cache[bundle];
      addExtensions(bundle);
    }
  };

  require.list = function() {
    var list = [];
    for (var item in modules) {
      if (has.call(modules, item)) {
        list.push(item);
      }
    }
    return list;
  };

  var hmr = globals._hmr && new globals._hmr(_resolve, require, modules, cache);
  require._cache = cache;
  require.hmr = hmr && hmr.wrap;
  require.brunch = true;
  globals.require = require;
})();

(function() {
var global = window;
var __makeRelativeRequire = function(require, mappings, pref) {
  var none = {};
  var tryReq = function(name, pref) {
    var val;
    try {
      val = require(pref + '/node_modules/' + name);
      return val;
    } catch (e) {
      if (e.toString().indexOf('Cannot find module') === -1) {
        throw e;
      }

      if (pref.indexOf('node_modules') !== -1) {
        var s = pref.split('/');
        var i = s.lastIndexOf('node_modules');
        var newPref = s.slice(0, i).join('/');
        return tryReq(name, newPref);
      }
    }
    return none;
  };
  return function(name) {
    if (name in mappings) name = mappings[name];
    if (!name) return;
    if (name[0] !== '.' && pref) {
      var val = tryReq(name, pref);
      if (val !== none) return val;
    }
    return require(name);
  }
};
require.register("javascripts/controllers/orders/checkout.js", function(exports, require, module) {
"use strict";

/**
 * Checkout class
 */
var Checkout = {

  /**
   * Initializer
   */
  init: function init() {

    this.postBankDetails();
  },

  /**
   * Post bank details to the `form_url`
   */
  postBankDetails: function postBankDetails() {

    var bankDetails = $("#bank-details").data();
    var parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

    PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);
  }

};

module.exports = Checkout;
});

require.register("javascripts/controllers/pages/demo.js", function(exports, require, module) {
"use strict";

/**
 * Apply Wirecard Class
 */
var Demo = {

  /**
   * Initializer
   */
  init: function init() {

    $('#js-slider').lightSlider({
      "item": 1,
      "loop": true,
      "slideMargin": 0,
      "pager": false,
      "auto": true,
      "pause": "3000",
      "speed": "1000",
      "adaptiveHeight": true,
      "verticalHeight": 1000,
      "mode": "fade",
      "enableDrag": false,
      "enableTouch": true
    });
  }

};

module.exports = Demo;
});

require.register("javascripts/controllers/pages/home.js", function(exports, require, module) {
"use strict";

/**
 * Apply Wirecard Class
 */
var Home = {

  /**
   * Initializer
   */
  init: function init() {

    $('#js-slider').lightSlider({
      "item": 1,
      "loop": true,
      "slideMargin": 0,
      "pager": false,
      "auto": true,
      "pause": "3000",
      "speed": "1000",
      "adaptiveHeight": true,
      "verticalHeight": 1000,
      "mode": "fade",
      "enableDrag": false,
      "enableTouch": true
    });
  }

};

module.exports = Home;
});

require.register("javascripts/controllers/pages/menu.js", function(exports, require, module) {
'use strict';

/**
 * Menu Class
 */
var Menu = {

  /**
   * Initializer
   */
  init: function init() {

    console.log('fuck');
  }

};

module.exports = Menu;
});

require.register("javascripts/controllers/shops/apply_wirecard.js", function(exports, require, module) {
"use strict";

/**
 * Apply Wirecard Class
 */
var ApplyWirecard = {

  /**
   * Initializer
   */
  init: function init() {

    this.postShopDetails();
  },

  /**
   * Post shop details to the `form_url`
   */
  postShopDetails: function postShopDetails() {

    var shopDetails = $("#shop-details").data();
    var parsedShopDetails = Casing.objectToUnderscoreCase(shopDetails);

    PostForm.send(parsedShopDetails, parsedShopDetails['form_url']);
  }

};

module.exports = ApplyWirecard;
});

require.register("javascripts/helpers/search.js", function(exports, require, module) {
"use strict";

/**
 * Search Class
 */
var Search = {

  /**
   * Initializer
   */
  init: function init() {

    this.searchable_input();
  },

  /**
   * We make the input searchable on click
   */
  searchable_input: function searchable_input() {

    var self = this;

    $("#js-search-click").on("click", function () {
      self.show_searcher();
    });

    $(document).click(function () {
      self.show_clicker();
    });

    $("#js-search-input").click(function (e) {
      e.stopPropagation();
    });

    $("#js-search-click").click(function (e) {
      e.stopPropagation();
    });
  },

  show_clicker: function show_clicker() {

    $("#js-search-input").hide();
    $("#js-search-click").show();
  },

  show_searcher: function show_searcher() {

    $(this).hide();
    $("#js-search-input").show();
    $("#js-search-input #search").focus();
  }

};

module.exports = Search;
});

require.register("javascripts/initialize.js", function(exports, require, module) {
"use strict";

document.addEventListener('DOMContentLoaded', function () {

  /**
   * Controllers loader by Loschcode
   * Damn simple class loader.
   */
  var routes = $("#js-routes").data();
  var helpers = $("#js-helpers").data();

  try {

    for (var helper in helpers) {

      var _obj = require("javascripts/helpers/" + helper);
      _obj.init();
    }
  } catch (err) {

    console.log("Unable to initialize #js-helpers");
    return;
  }

  try {

    var obj = require("javascripts/controllers/" + routes.controller + "/" + routes.action);
  } catch (err) {

    console.log("Unable to initialize #js-routes `" + routes.controller + "`.`" + routes.action + "`");
    return;
  }

  /**
   * Initialization
   */
  obj.init();
});
});

require.register("___globals___", function(exports, require, module) {
  
});})();require('___globals___');


//# sourceMappingURL=app.js.map