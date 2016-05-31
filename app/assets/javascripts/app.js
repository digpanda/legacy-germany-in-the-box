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

require.register("javascripts/controllers/orders/manage_cart.js", function(exports, require, module) {
"use strict";

/**
 * ManageCart class
 */
var ManageCart = {

  /**
   * Initializer
   */
  init: function init() {

    this.onSetAddress();
  },

  onSetAddress: function onSetAddress() {

    $(".js-set-address-link").click(function (e) {

      e.preventDefault();
      ManageCart.forceLogin(this);
    });
  },


  /**
   * Send next destination and trigger log-in if not logged-in already
   */
  forceLogin: function forceLogin(el) {

    var location = $(el).attr("href");
    var self = this;

    var User = require("javascripts/models/user");

    User.isAuth(function (res) {

      // If the user isn't auth
      // We force the trigger and
      // Set the new location programmatically
      if (res === false) {

        self.setRedirectLocation(location);
        $("#sign_in_link").click();
      } else {

        // Else we just continue to do what we were doing
        window.location.href = location;
      }
    });
  },

  // Should be in a lib
  setRedirectLocation: function setRedirectLocation(location) {

    $.ajax({
      method: "PATCH",
      url: "/set_redirect_location",
      data: { "location": location }

    }).done(function (res) {

      // callback {"status": "ok"}

    });
  }

};

module.exports = ManageCart;
});

require.register("javascripts/controllers/pages/home.js", function(exports, require, module) {
'use strict';

/**
 * Apply Wirecard Class
 */
var Home = {

  /**
   * Initializer
   */
  init: function init() {

    $('#js-slider').show(); // Page hook fix : we display:none; and cancel it here

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

    $.widget('custom.catcomplete', $.ui.autocomplete, {
      _create: function _create() {
        this._super();
        this.widget().menu('option', 'items', '> :not(.ui-autocomplete-category)');
      },
      _renderMenu: function _renderMenu(ul, items) {
        var that = this,
            search_category = '';
        $.each(items, function (index, item) {
          var li;
          if (item.sc != search_category) {
            ul.append("<li class='ui-autocomplete-category'>" + item.sc + '</li>');
            search_category = item.sc;
          }
          li = that._renderItemData(ul, item);
          if (item.sc) {
            li.attr('aria-label', item.sc + ' : ' + item.label);
          }
        });
      }
    });

    $('#products_search_keyword').catcomplete({
      delay: 1000,
      source: '/products/autocomplete_product_name',
      select: function select(a, b) {
        $(this).val(b.item.value);
        $('#search_products_form').submit();
      }
    });
  }

};

module.exports = Home;
});

require.register("javascripts/controllers/pages/menu.js", function(exports, require, module) {
"use strict";

/**
 * Menu Class
 */
var Menu = {

  /**
   * Initializer
   */
  init: function init() {}

};

module.exports = Menu;
});

require.register("javascripts/controllers/shop_applications/new.js", function(exports, require, module) {
'use strict';

/**
 * ShopApplicationsNew Class
 */
var ShopApplicationsNew = {

  /**
   * Initializer
   */
  init: function init() {

    if ($('#add_sales_channel_btn').length > 0) {

      $('#add_sales_channel_btn').click();

      $('#edit_app_submit_btn').click(function () {
        $('input.dynamical-required').each(function () {
          if ($(this).val().length == 0) {
            $(this).addClass('invalidBorderClass');
          } else {
            $(this).removeClass('invalidBorderClass');
          }
        });

        if ($('.invalidBorderClass').length > 0) {
          return false;
        }
      });
    }
  }

};

module.exports = ShopApplicationsNew;
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

require.register("javascripts/initialize.js", function(exports, require, module) {
"use strict";

$(document).ready(function () {

  /**
   * Controllers loader by Loschcode
   * Damn simple class loader.
   */
  var routes = $("#js-routes").data();
  var starters = require("javascripts/starters");

  try {

    for (var idx in starters) {

      console.warn('Loading starter : ' + starters[idx]);

      var formatted_starter = Casing.underscoreCase(starters[idx]).replace('-', '_');
      var _obj = require("javascripts/starters/" + formatted_starter);
      _obj.init();
    }
  } catch (err) {

    console.error("Unable to initialize #js-starters");
    return;
  }

  try {

    var obj = require("javascripts/controllers/" + routes.controller + "/" + routes.action);
  } catch (err) {

    console.error("Unable to initialize #js-routes `" + routes.controller + "`.`" + routes.action + "`");
    return;
  }

  /**
   * Initialization
   */
  obj.init();
});
});

require.register("javascripts/models.js", function(exports, require, module) {
'use strict';

/**
 * Models Class
 */
var Models = ['user'];

module.exports = Models;
});

require.register("javascripts/models/user.js", function(exports, require, module) {
"use strict";

/**
 * User Class
 */
var User = {

  /**
   * Check if user is auth or not via API call
   */
  isAuth: function isAuth(callback) {

    $.ajax({
      method: "GET",
      url: "/users/is_auth",
      data: {}

    }).done(function (res) {

      callback(res.is_auth);
    });
  }

};

module.exports = User;
});

require.register("javascripts/starters.js", function(exports, require, module) {
'use strict';

/**
 * Starters Class
 */
var Starters = ['footer', 'product_favorite', 'product_lightbox', 'search'];

module.exports = Starters;
});

require.register("javascripts/starters/footer.js", function(exports, require, module) {
'use strict';

/**
 * Footer Class
 */
var Footer = {

  /**
   * Initializer
   */
  init: function init() {

    this.stickyFooter();
  },

  /**
   * Put the footer on the bottom of the page
   */
  stickyFooter: function stickyFooter() {

    self = this;

    if ($('.js-footer-stick').length > 0) {

      Footer.processStickyFooter();

      $(window).resize(function () {

        Footer.processStickyFooter();
      });
    }
  },

  processStickyFooter: function processStickyFooter() {

    var docHeight, footerHeight, footerTop;

    docHeight = $(window).height();
    footerHeight = $('.js-footer-stick').height();
    footerTop = $('.js-footer-stick').position().top + footerHeight;

    if (footerTop < docHeight) {
      $('.js-footer-stick').css('margin-top', 10 + (docHeight - footerTop) + 'px');
    }
  }

};

module.exports = Footer;
});

require.register("javascripts/starters/product_favorite.js", function(exports, require, module) {
"use strict";

/**
 * ProductFavorite Class
 */
var ProductFavorite = {

  /**
   * Initializer
   */
  init: function init() {

    this.manageHeartClick();
  },

  /**
   * When the heart is clicked
   */
  manageHeartClick: function manageHeartClick() {

    self = this;

    $(".js-heart-click").on("click", function (e) {

      e.preventDefault();

      var productId = $(this).attr('data-product-id');
      var favorite = $(this).attr('data-favorite'); // Should be converted

      if (favorite == '1') {

        // We remove the favorite front data
        $(this).removeClass('+red');
        $(this).attr('data-favorite', '0'); // marche pas
        //$(this).data('favorite', '0') // marche pas non plus

        ProductFavorite.doUnlike(this, productId, function (res) {

          var favoritesCount = res.favorites.length;
          $('#total-likes').html(favoritesCount);
        });
      } else {

        // We change the style before the callback for speed reason
        $(this).addClass('+red');
        $(this).attr('data-favorite', '1');

        ProductFavorite.doLike(this, productId, function (res) {

          var favoritesCount = res.favorites.length;
          $('#total-likes').html(favoritesCount);
        });
      }
    });
  },

  doLike: function doLike(el, productId, callback) {

    $.ajax({
      method: "PATCH",
      url: "/products/" + productId + "/like",
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      // If it's a Unauthorized code, it means we are not logged in, let's trigger.
      if (err.status == 401) {

        $(el).removeClass('+red');
        $("#sign_in_link").click();
      }
    });
  },

  doUnlike: function doUnlike(el, productId, callback) {

    $.ajax({
      method: "PATCH",
      url: "/products/" + productId + "/unlike",
      data: {}

    }).done(function (res) {

      callback(res);
    });
  }
};

module.exports = ProductFavorite;
});

require.register("javascripts/starters/product_lightbox.js", function(exports, require, module) {
'use strict';

/**
 * ProductLightbox Class
 */
var ProductLightbox = {

  /**
   * Initializer
   */
  init: function init() {

    this.selectVariantOptionLoader();
  },

  /**
   * When in the lightbox if the customer change the variant option
   * It will reload everything through AJAX
   */
  selectVariantOptionLoader: function selectVariantOptionLoader() {

    if ($('select.variant-option').length > 0) {

      $('select.variant-option').change(function () {

        var product_id = $(this).attr('product_id');
        var option_ids = [];

        $('ul.product-page-meta-info [id^="product_' + product_id + '_variant"]').each(function (o) {
          option_ids.push($(this).val());
        });

        $.ajax({
          dataType: 'json',
          data: { option_ids: this.value.split(',') },
          url: '/products/' + product_id + '/get_sku_for_options',
          success: function success(json) {
            var qc = $('#product_quantity_' + product_id).empty();

            for (var i = 1; i <= parseInt(json['quantity']); ++i) {
              qc.append('<option value="' + i + '">' + i + '</option>');
            }

            $('#product_price_' + product_id).text(json['price'] + ' ' + json['currency']);
            $('#product_discount_' + product_id).text(json['discount'] + ' ' + '%');
            $('#product_saving_' + product_id).text(parseFloat(json['price']) * parseInt(json['discount']) / 100 + ' ' + json['currency']);
            $('#product_inventory_' + product_id).text(json['quantity']);

            var fotorama = $('#product_quick_view_dialog_' + product_id).find('.fotorama').fotorama().data('fotorama');
            fotorama.load([{ img: json['img0_url'] }, { img: json['img1_url'] }, { img: json['img2_url'] }, { img: json['img3_url'] }]);
          }
        });
      });
    }
  }

};

module.exports = ProductLightbox;
});

require.register("javascripts/starters/search.js", function(exports, require, module) {
'use strict';

/**
 * Search Class
 */
var Search = {

  /**
   * Initializer
   */
  init: function init() {

    this.searchableInput();
  },

  /**
   * We make the input searchable on click
   */
  searchableInput: function searchableInput() {

    $(document).on('submit', '#search-form', function (e) {

      var search = $('#search').val();

      /**
       * If the research is empty it doesn't trigger the submit
       */
      if (!search.trim()) {
        return false;
      } else {
        return true;
      }
    });
  }

};

module.exports = Search;
});

require.register("___globals___", function(exports, require, module) {
  
});})();require('___globals___');


//# sourceMappingURL=app.js.map