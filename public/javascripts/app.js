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

    var Casing = require("javascripts/lib/casing");
    var PostForm = require("javascripts/lib/post_form.js");

    var bankDetails = $("#bank-details").data();
    var parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

    PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);
  }

};

module.exports = Checkout;
});

require.register("javascripts/controllers/orders/manage_cart.js", function(exports, require, module) {
'use strict';

/**
 * ManageCart class
 */
var ManageCart = {

  /**
   * Initializer
   */
  init: function init() {

    this.multiSelectSystem();
    this.orderItemHandleQuantity();
  },

  multiSelectSystem: function multiSelectSystem() {

    $('select.sku-variants-options').multiselect({
      enableCaseInsensitiveFiltering: true,
      maxHeight: 400
    }).multiselect('disable');
  },

  orderItemHandleQuantity: function orderItemHandleQuantity() {

    $('.js-set-quantity-minus').click(function () {

      var orderItemId = $(this).data('orderItemId');
      var currentQuantity = $('#order-item-quantity-' + orderItemId).val();

      if (currentQuantity > 0) {
        currentQuantity--;
        ManageCart.orderItemSetQuantity(orderItemId, currentQuantity);
      }
    });

    $('.js-set-quantity-plus').click(function () {

      var orderItemId = $(this).data('orderItemId');
      var currentQuantity = $('#order-item-quantity-' + orderItemId).val();

      currentQuantity++;
      ManageCart.orderItemSetQuantity(orderItemId, currentQuantity);
    });
  },

  orderItemSetQuantity: function orderItemSetQuantity(orderItemId, orderItemQuantity) {

    var OrderItem = require("javascripts/models/order_item");

    OrderItem.setQuantity(orderItemId, orderItemQuantity, function (res) {

      var Messages = require("javascripts/lib/messages");

      if (res.success === false) {

        Messages.makeError(res.error);
      } else {

        /**
         * Scheme
         * amount_in_carts integer
         * duty_cost_with_currency string
         * shipping_cost_with_currency string
         * total_with_currency string
         */

        // We first refresh the value in the HTML
        $('#order-item-quantity-' + orderItemId).val(orderItemQuantity);
        $('#total-products').html(res.data.amount_in_carts);
        $('#order-subtotal').html(res.data.total_price_with_currency);
        $('#order-duty-cost').html(res.data.duty_cost_with_currency);
        $('#order-shipping-cost').html(res.data.shipping_cost_with_currency);
        $('#order-total-price-in-yuan').html(res.data.total_with_currency);
      }
    });
  }

};

/* SAME HERE
  // Should be in a lib
  setRedirectLocation: function(location) {

    $.ajax({
      method: "PATCH",
      url: "api/set_redirect_location",
      data: {"location": location}


    }).done(function(res) {

      // callback {"status": "ok"}

    });

  },
*/

module.exports = ManageCart;
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

    /*
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
    */

  }

};

module.exports = Home;
});

require.register("javascripts/controllers/products/show_skus.js", function(exports, require, module) {
'use strict';

/**
 * ProductsShowSkus Class
 */
var ProductsShowSkus = {

  /**
   * Initializer
   */
  init: function init() {

    if ($('#js-show-skus').length > 0) {

      var showSkus = $('#js-show-skus').data();

      $('select.sku-variants-options').multiselect({
        nonSelectedText: showSkus.translationNonSelectedText,
        nSelectedText: showSkus.translationNSelectedText,
        numberDisplayed: 3,
        maxHeight: 400
      }).multiselect('disable');
    }
  }

};

module.exports = ProductsShowSkus;
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
    }
  }

};

module.exports = ShopApplicationsNew;
});

require.register("javascripts/controllers/shopkeeper/wirecards/apply.js", function(exports, require, module) {
"use strict";

/**
 * Apply Wirecard Class
 */
var ShopkeeperWirecardApply = {

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

    var Casing = require("javascripts/lib/casing");
    var PostForm = require("javascripts/lib/post_form.js");

    var shopDetails = $("#shop-details").data();
    var parsedShopDetails = Casing.objectToUnderscoreCase(shopDetails);

    PostForm.send(parsedShopDetails, parsedShopDetails['form_url']);
  }

};

module.exports = ShopkeeperWirecardApply;
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

    var Casing = require("javascripts/lib/casing");

    for (var idx in starters) {

      console.info('Loading starter : ' + starters[idx]);

      var formatted_starter = Casing.underscoreCase(starters[idx]).replace('-', '_');
      var _obj = require("javascripts/starters/" + formatted_starter);
      _obj.init();
    }
  } catch (err) {

    console.error("Unable to initialize #js-starters (" + err + ")");
    return;
  }

  try {

    var obj = require("javascripts/controllers/" + routes.controller + "/" + routes.action);
    console.info("Loading controller " + routes.controller + "/" + routes.action);
  } catch (err) {

    console.warn("Unable to initialize #js-routes `" + routes.controller + "`.`" + routes.action + "`");
    return;
  }

  /**
   * Initialization
   */
  obj.init();
});
});

require.register("javascripts/lib/casing.js", function(exports, require, module) {
"use strict";

/**
 * Casing Class
 */
var Casing = {

  /**
   * CamelCase to underscored case
   */
  underscoreCase: function underscoreCase(string) {
    return string.replace(/(?:^|\.?)([A-Z])/g, function (x, y) {
      return "_" + y.toLowerCase();
    }).replace(/^_/, "");
  },

  /**
   * Undescored to CamelCase
   */
  camelCase: function camelCase(string) {
    return string.replace(/(\-[a-z])/g, function ($1) {
      return $1.toUpperCase().replace('-', '');
    });
  },

  /**
   * Convert an object to underscore case
   */
  objectToUnderscoreCase: function objectToUnderscoreCase(obj) {

    var parsed = {};
    for (var key in obj) {

      var new_key = this.underscoreCase(key);
      parsed[new_key] = obj[key];
    }

    return parsed;
  }

};

module.exports = Casing;
});

require.register("javascripts/lib/foreign/datepicker-de.js", function(exports, require, module) {
"use strict";

/* German initialisation for the jQuery UI date picker plugin. */
/* Written by Milian Wolff (mail@milianw.de). */
(function (factory) {
  if (typeof define === "function" && define.amd) {

    // AMD. Register as an anonymous module.
    define(["../widgets/datepicker"], factory);
  } else {

    // Browser globals
    factory(jQuery.datepicker);
  }
})(function (datepicker) {

  datepicker.regional.de = {
    closeText: "Schließen",
    prevText: "&#x3C;Zurück",
    nextText: "Vor&#x3E;",
    currentText: "Heute",
    monthNames: ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"],
    monthNamesShort: ["Jan", "Feb", "Mär", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"],
    dayNames: ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"],
    dayNamesShort: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
    dayNamesMin: ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"],
    weekHeader: "KW",
    dateFormat: "dd.mm.yy",
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: "" };
  datepicker.setDefaults(datepicker.regional.de);

  return datepicker.regional.de;
});
});

require.register("javascripts/lib/foreign/datepicker-zh-CN.js", function(exports, require, module) {
"use strict";

/* Chinese initialisation for the jQuery UI date picker plugin. */
/* Written by Cloudream (cloudream@gmail.com). */
(function (factory) {
  if (typeof define === "function" && define.amd) {

    // AMD. Register as an anonymous module.
    define(["../widgets/datepicker"], factory);
  } else {

    // Browser globals
    factory(jQuery.datepicker);
  }
})(function (datepicker) {

  datepicker.regional["zh-CN"] = {
    closeText: "关闭",
    prevText: "&#x3C;上月",
    nextText: "下月&#x3E;",
    currentText: "今天",
    monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
    monthNamesShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
    dayNames: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
    dayNamesShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
    dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"],
    weekHeader: "周",
    dateFormat: "yy-mm-dd",
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: true,
    yearSuffix: "年" };
  datepicker.setDefaults(datepicker.regional["zh-CN"]);

  return datepicker.regional["zh-CN"];
});
});

require.register("javascripts/lib/messages.js", function(exports, require, module) {
'use strict';

/**
 * Messages Class
 */
var Messages = { // NOTE : We should use a template system to handle the HTML here

  makeError: function makeError(error) {

    $("#messages-container").html('<div id="message-error" class="col-md-6 col-md-push-3 col-md-pull-3 message__error +centered">' + error + '</div>');
    Messages.activateHide('#message-error', 3000);
  },

  makeSuccess: function makeSuccess(success) {

    $("#messages-container").html('<div id="message-success" class="col-md-6 col-md-push-3 col-md-pull-3 message__success +centered">' + success + '</div>');
    Messages.activateHide('#message-success', 4000);
  },

  activateHide: function activateHide(el, time) {

    setTimeout(function () {
      $(el).fadeOut();
    }, time);
  }

};

module.exports = Messages;
});

require.register("javascripts/lib/post_form.js", function(exports, require, module) {
"use strict";

/**
 * PostForm Class
 */
var PostForm = {

  /**
   * Generate and create a form
   */
  send: function send(params, path, target, method) {

    var method = method || "POST";
    var path = path || "";
    var target = target || "";

    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);
    form.setAttribute("target", target);

    for (var key in params) {

      if (params.hasOwnProperty(key)) {

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

module.exports = PostForm;
});

require.register("javascripts/models.js", function(exports, require, module) {
"use strict";

/**
 * Models Class
 */
var Models = [

  // Not currently in use (please load each model on a case per case basis)
  //
];

module.exports = Models;
});

require.register("javascripts/models/order_item.js", function(exports, require, module) {
"use strict";

/**
 * OrderItem Class
 */
var OrderItem = {

  /**
   * Check if user is auth or not via API call
   */
  setQuantity: function setQuantity(orderItemId, quantity, callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/guest/order_items/" + orderItemId + "/set_quantity",
      data: { "quantity": quantity }

    }).done(function (res) {

      callback(res);
    });
  }

};

module.exports = OrderItem;
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
    // NOT CURRENTLY IN USE IN THE SYSTEM (REMOVE COMMENT IF YOU ADD IT SOMEWHERE)

    $.ajax({
      method: "GET",
      url: "api/users/is_auth",
      data: {}

    }).done(function (res) {

      callback(res);
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
var Starters = ['bootstrap', 'china_city', 'datepicker', 'footer', 'images_control', 'images_handler', 'left_menu', 'messages', 'product_favorite', 'product_form', 'product_lightbox', 'search'];

module.exports = Starters;
});

require.register("javascripts/starters/bootstrap.js", function(exports, require, module) {
"use strict";

/**
 * Bootstrap Class
 */
var Bootstrap = {

  /**
   * Initializer
   */
  init: function init() {

    this.startPopover();
    this.startTooltip();
  },

  /**
   * 
   */
  startPopover: function startPopover() {

    $("a[rel~=popover], .has-popover").popover();
  },

  startTooltip: function startTooltip() {

    $("a[rel~=tooltip], .has-tooltip").tooltip();
  }

};

module.exports = Bootstrap;
});

require.register("javascripts/starters/china_city.js", function(exports, require, module) {
"use strict";

/**
 * ChinaCity Class
 */
var ChinaCity = {

    /**
     * Initializer
     */
    init: function init() {

        this.startChinaCity();
    },

    /**
     * 
     */
    startChinaCity: function startChinaCity() {

        $.fn.china_city = function () {
            return this.each(function () {
                var selects;
                selects = $(this).find('.city-select');
                return selects.change(function () {
                    var $this, next_selects;
                    $this = $(this);
                    next_selects = selects.slice(selects.index(this) + 1);
                    $("option:gt(0)", next_selects).remove();
                    if (next_selects.first()[0] && $this.val() && !$this.val().match(/--.*--/)) {
                        return $.get("/china_city/" + $(this).val(), function (data) {
                            var i, len, option;
                            if (data.data != null) {
                                data = data.data;
                            }
                            for (i = 0, len = data.length; i < len; i++) {
                                option = data[i];
                                next_selects.first()[0].options.add(new Option(option[0], option[1]));
                            }
                            return next_selects.trigger('china_city:load_data_completed');
                        });
                    }
                });
            });
        };

        $(document).ready(function () {
            $('.city-group').china_city();
        });
    }

};

module.exports = ChinaCity;
});

require.register("javascripts/starters/datepicker.js", function(exports, require, module) {
'use strict';

/**
 * Datepicker Class
 */
var Datepicker = {

  /**
   * Initializer
   */
  init: function init() {

    if ($('#js-show-datepicker').length > 0) {

      var showDatepicker = $('#js-show-datepicker').data();
      var language = showDatepicker.language ? showDatepicker.language : 'de';

      if (language == 'de') {
        require("javascripts/lib/foreign/datepicker-de.js");
      } else {
        require("javascripts/lib/foreign/datepicker-zh-CN.js");
      }

      $("#datepicker").datepicker({
        changeMonth: true,
        changeYear: true,
        yearRange: '1945:' + new Date().getFullYear(),
        dateFormat: "yy-mm-dd"
      });
    }
  }

};

module.exports = Datepicker;
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

require.register("javascripts/starters/images_control.js", function(exports, require, module) {
'use strict';

/**
 * ImageControl Class
 */
var ImagesControl = {

  /**
   * Initializer
   */
  init: function init() {

    this.validateImageFile();
  },

  validateImageFile: function validateImageFile() {

    console.log('loaded');

    $("input[class^=img-file-upload]").on('change', function () {

      var inputFile = this;

      var maxExceededMessage = ""; // #{I18n.t(:max_exceeded_message, scope: :image_upload)} to catch
      var extErrorMessage = ""; // #{I18n.t(:ext_error_message, scope: :image_upload)} to catch
      var allowedExtension = ["jpg", "JPG", "jpeg", "JPEG", "png", "PNG"];

      var extName;
      var maxFileSize = 1048576;
      var sizeExceeded = false;
      var extError = false;

      $.each(inputFile.files, function () {
        if (this.size && maxFileSize && this.size > maxFileSize) {
          sizeExceeded = true;
        };
        extName = this.name.split('.').pop();
        if ($.inArray(extName, allowedExtension) == -1) {
          extError = true;
        };
      });
      if (sizeExceeded) {
        window.alert(maxExceededMessage);
        $(inputFile).val('');
      };

      if (extError) {
        window.alert(extErrorMessage);
        $(inputFile).val('');
      };
    });
  }

};

module.exports = ImagesControl;
});

require.register("javascripts/starters/images_handler.js", function(exports, require, module) {
"use strict";

/**
 * ImagesHandler Class
 */
var ImagesHandler = {

  /**
   * Initializer
   */
  init: function init() {

    this.startImagesHandler();
  },

  /**
   * 
   */
  startImagesHandler: function startImagesHandler() {

    $(".img-file-upload").each(function () {
      var fileElement = $(this);
      $(this).change(function (event) {
        var input = $(event.currentTarget);
        var file = input[0].files[0];
        var reader = new FileReader();
        reader.onload = function (e) {
          var image_base64 = e.target.result;
          $(fileElement.attr('img_id')).attr("src", image_base64);
        };
        reader.readAsDataURL(file);
      });
    });

    $("img").one("error", function (e) {
      $(this).attr('src', '/assets/no_image_available.jpg');
    });
  }

};

module.exports = ImagesHandler;
});

require.register("javascripts/starters/left_menu.js", function(exports, require, module) {
'use strict';

/**
 * LeftMenu Class
 */
var LeftMenu = {

    /**
     * Initializer
     */
    init: function init() {

        this.startLeftMenu();
    },

    /**
     * 
     */
    startLeftMenu: function startLeftMenu() {

        $('#left_menu > ul > li > a').click(function () {
            $('#left_menu li').removeClass('active');
            $(this).closest('li').addClass('active');
            var checkElement = $(this).next();
            if (checkElement.is('ul') && checkElement.is(':visible')) {
                $(this).closest('li').removeClass('active');
                checkElement.slideUp('normal');
            }
            if (checkElement.is('ul') && !checkElement.is(':visible')) {
                $('#left_menu ul ul:visible').slideUp('normal');
                checkElement.slideDown('normal');
            }
            if ($(this).closest('li').find('ul').children().length == 0) {
                return true;
            } else {
                return false;
            }
        });
    }

};

module.exports = LeftMenu;
});

require.register("javascripts/starters/messages.js", function(exports, require, module) {
"use strict";

/**
 * Messages Class
 */
var Messages = {

  /**
   * Initializer
   */
  init: function init() {

    this.hideMessages();
  },

  /**
   * 
   */
  hideMessages: function hideMessages() {

    var Messages = require("javascripts/lib/messages");

    if ($("#message-error").length > 0) {
      Messages.activateHide('#message-error', 3000);
    }

    if ($("#message-success").length > 0) {
      Messages.activateHide('#message-success', 4000);
    }
  }

};

module.exports = Messages;
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
        $(this).attr('data-favorite', '0');

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
      url: "/api/products/" + productId + "/like",
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
      url: "/api/products/" + productId + "/unlike",
      data: {}

    }).done(function (res) {

      callback(res);
    });
  }
};

module.exports = ProductFavorite;
});

require.register("javascripts/starters/product_form.js", function(exports, require, module) {
"use strict";

/**
 * ProductForm Class
 */
var ProductForm = {

  /**
   * Initializer
   */
  init: function init() {

    this.manageShopkeeperProductForm();
  },

  manageShopkeeperProductForm: function manageShopkeeperProductForm() {

    if ($("#js-product-form").length > 0) {

      var productForm = $("#js-product-form").data();
      var productId = productForm.productId;

      $('select.product-categories').multiselect({
        nonSelectedText: productForm.translationNonSelectedText,
        nSelectedText: productForm.translationNSelectedText,
        numberDisplayed: 5,
        maxHeight: 400
      }).multiselect();

      $('#edit_product_submit_btn').click(function () {

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

      $('a[rel=popover]').popover();

      var panel_cnt = $("#variants_panel_" + productId).children('.panel-body').find('.panel').length;
      if (panel_cnt == 0) $("#a_add_variant_" + productId).click();
    }
  }

};

module.exports = ProductForm;
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
          url: '/api/products/' + product_id + '/get_sku_for_options',
          success: function success(json) {
            var qc = $('#product_quantity_' + product_id).empty();

            for (var i = 1; i <= parseInt(json['quantity']); ++i) {
              qc.append('<option value="' + i + '">' + i + '</option>');
            }

            $('#product_price_' + product_id).text(json['price'] + ' ' + json['currency']);
            $('#product_discount_' + product_id).text(json['discount'] + ' ' + '%');
            $('#product_saving_' + product_id).text(parseFloat(json['price']) * parseInt(json['discount']) / 100 + ' ' + json['currency']);
            $('#product_inventory_' + product_id).text(json['quantity']);

            var fotorama = $('.fotorama').fotorama().data('fotorama');
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