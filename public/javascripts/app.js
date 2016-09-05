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

    $('.js-set-quantity-minus').click(function (e) {

      e.preventDefault();

      var orderItemId = $(this).data('orderItemId');
      var orderShopId = $(this).data('orderShopId');
      var currentQuantity = $('#order-item-quantity-' + orderItemId).val();

      if (currentQuantity > 0) {
        currentQuantity--;
        ManageCart.orderItemSetQuantity(orderShopId, orderItemId, currentQuantity);
      }
    });

    $('.js-set-quantity-plus').click(function (e) {

      e.preventDefault();

      var orderItemId = $(this).data('orderItemId');
      var orderShopId = $(this).data('orderShopId');
      var currentQuantity = $('#order-item-quantity-' + orderItemId).val();

      currentQuantity++;
      ManageCart.orderItemSetQuantity(orderShopId, orderItemId, currentQuantity);
    });
  },

  orderItemSetQuantity: function orderItemSetQuantity(orderShopId, orderItemId, orderItemQuantity) {

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
         * shipping_cost_with_currency_yuan string
         * total_with_currency string
         */

        // We first refresh the value in the HTML
        $('#order-item-quantity-' + orderItemId).val(orderItemQuantity);
        $('#total-products-' + orderShopId).html(res.data.amount_in_carts);
        $('#order-subtotal-' + orderShopId).html(res.data.total_price_with_currency_yuan);
        //$('#order-duty-cost-'+orderShopId).html(res.data.duty_cost_with_currency);
        //$('#order-shipping-cost-'+orderShopId).html(res.data.shipping_cost_with_currency_yuan);
        $('#order-duty-and-shipping-cost-' + orderShopId).html(res.data.duty_and_shipping_cost_with_currency_yuan);
        $('#order-total-sum-in-yuan-' + orderShopId).html(res.data.total_sum_in_yuan);
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

require.register("javascripts/controllers/orders/show.js", function(exports, require, module) {
'use strict';

/**
 * OrdersShow class
 */
var OrdersShow = {

  /**
   * Initializer
   */
  init: function init() {

    this.multiSelectSystem();
  },

  multiSelectSystem: function multiSelectSystem() {

    $('select.sku-variants-options').multiselect({
      enableCaseInsensitiveFiltering: true,
      maxHeight: 400
    }).multiselect('disable');
  }

};

module.exports = OrdersShow;
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

require.register("javascripts/controllers/products/clone_sku.js", function(exports, require, module) {
'use strict';

var Translation = require('javascripts/lib/translation');

/**
 * ProductCloneSku Class
 */
var ProductCloneSku = {

  /**
   * Initializer
   */
  init: function init() {
    // WE SHOULD DEFINITELY REFACTOR THOSE 3 CLASSES (NEW, EDIT, CLONE) INTO ONE

    $('select.sku-variants-options').multiselect({
      nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
      nSelectedText: Translation.find('n_selected_text', 'multiselect'),
      numberDisplayed: 3,
      maxHeight: 400,
      onChange: function onChange(option, checked) {
        var v = $('.sku-variants-options');
        if (v.val()) {
          v.next().removeClass('invalidBorderClass');
        } else {
          v.next().addClass('invalidBorderClass');
        }
      }
    });

    $('#edit_product_detail_form_btn').click(function () {
      var v = $('select.sku-variants-options');

      if (v.val() == null) {
        v.next().addClass('invalidBorderClass');
        return false;
      }

      if ($('img.img-responsive[src=""]').length >= 4) {
        $('.fileUpload:first').addClass('invalidBorderClass');
        return false;
      }

      return true;
    });

    $('input.img-file-upload').click(function () {
      if ($('img.img-responsive[src=""]').length > 0) {
        $('.fileUpload').removeClass('invalidBorderClass');
      }
    });
  }

};

module.exports = ProductCloneSku;
});

require.register("javascripts/controllers/products/edit_sku.js", function(exports, require, module) {
'use strict';

var Translation = require('javascripts/lib/translation');

/**
 * ProductEditSku Class
 */
var ProductEditSku = {

  /**
   * Initializer
   */
  init: function init() {
    // WE SHOULD DEFINITELY REFACTOR THOSE 3 CLASSES (NEW, EDIT, CLONE) INTO ONE

    $('select.sku-variants-options').multiselect({
      nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
      nSelectedText: Translation.find('n_selected_text', 'multiselect'),
      numberDisplayed: 3,
      maxHeight: 400,
      onChange: function onChange(option, checked) {
        var v = $('.sku-variants-options');
        if (v.val()) {
          v.next().removeClass('invalidBorderClass');
        } else {
          v.next().addClass('invalidBorderClass');
        }
      }
    });

    $('#edit_product_detail_form_btn').click(function () {
      var v = $('select.sku-variants-options');

      if (v.val() == null) {
        v.next().addClass('invalidBorderClass');
        return false;
      }

      if ($('img.img-responsive[src=""]').length >= 4) {
        $('.fileUpload:first').addClass('invalidBorderClass');
        return false;
      }

      return true;
    });

    $('input.img-file-upload').click(function () {
      if ($('img.img-responsive[src=""]').length > 0) {
        $('.fileUpload').removeClass('invalidBorderClass');
      }
    });
  }

};

module.exports = ProductEditSku;
});

require.register("javascripts/controllers/products/new_sku.js", function(exports, require, module) {
'use strict';

var Translation = require('javascripts/lib/translation');

/**
 * ProductNewSku Class
 */
var ProductNewSku = {

  /**
   * Initializer
   */
  init: function init() {
    // WE SHOULD DEFINITELY REFACTOR THOSE 3 CLASSES (NEW, EDIT, CLONE) INTO ONE

    $('select.sku-variants-options').multiselect({
      nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
      nSelectedText: Translation.find('n_selected_text', 'multiselect'),
      numberDisplayed: 3,
      maxHeight: 400,
      onChange: function onChange(option, checked) {
        var v = $('.sku-variants-options');
        if (v.val()) {
          v.next().removeClass('invalidBorderClass');
        } else {
          v.next().addClass('invalidBorderClass');
        }
      }
    });

    $('#edit_product_detail_form_btn').click(function () {
      var v = $('select.sku-variants-options');

      if (v.val() == null) {
        v.next().addClass('invalidBorderClass');
        return false;
      }

      if ($('img.img-responsive[src=""]').length >= 4) {
        $('.fileUpload:first').addClass('invalidBorderClass');
        return false;
      }

      return true;
    });

    $('input.img-file-upload').click(function () {
      if ($('img.img-responsive[src=""]').length > 0) {
        $('.fileUpload').removeClass('invalidBorderClass');
      }
    });
  }

};

/* UNUSED IN THE CURRENT SYSTEM
  validatePdfFile: function(inputFile) {

    var maxExceededMessage = ProductNewSku.data().translationMaxExceedMessage;
    var extErrorMessage = ProductNewSku.data().translationExtErrorMessage;
    var allowedExtension = ["pdf"];

    var extName;
    var maxFileSize = 2097152;
    var sizeExceeded = false;
    var extError = false;

    $.each(inputFile.files, function() {
      if (this.size && maxFileSize && this.size > maxFileSize) {sizeExceeded=true;};
      extName = this.name.split('.').pop();
      if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
    });
    if (sizeExceeded) {
      window.alert(maxExceededMessage);
      $(inputFile).val('');
    };

    if (extError) {
      window.alert(extErrorMessage);
      $(inputFile).val('');
    };
  }
**/
module.exports = ProductNewSku;
});

require.register("javascripts/controllers/products/show.js", function(exports, require, module) {
'use strict';

var Translation = require("javascripts/lib/translation");
/**
 * ProductsShow Class
 */
var ProductsShow = {

  /**
   * Initializer
   */
  init: function init() {

    this.handleProductGalery();
    this.handleSkuChange();
  },

  handleProductGalery: function handleProductGalery() {

    $(document).on('click', '#gallery a', function (e) {

      var image = $(this).data('image');
      var zoomImage = $(this).data('zoom-image');

      /**
       * Homemade Gallery System by Laurent
       */
      e.preventDefault();

      // Changing the image when we click on any thumbnail of the #gallery
      $('#main_image').attr('src', image);
      /*
      $('#main_image').magnify({
        speed: 0,
        src: zoomImage,
      });*/
    });

    // We don't forget to trigger the click to load the first image
    $('#gallery a:first').trigger('click');
  },

  /**
   * When the customer change of sku selection, it refreshes some datas (e.g. price)
   */
  handleSkuChange: function handleSkuChange() {

    $('select#option_ids').change(function () {

      var productId = $(this).attr('product_id');
      var optionIds = $(this).val().split(',');

      var ProductSku = require("javascripts/models/product_sku");
      var Messages = require("javascripts/lib/messages");

      ProductSku.show(productId, optionIds, function (res) {

        if (res.success === false) {

          Messages.makeError(res.error);
        } else {

          ProductsShow.skuChangeDisplay(productId, res);
        }
      });
    });
  },

  skuHideDiscount: function skuHideDiscount() {

    $('#product_discount_with_currency_euro').hide();
    $('#product_discount_with_currency_yuan').hide();
    $('#product_discount').hide();

    $('#product_discount').removeClass('+discount');
  },

  skuShowDiscount: function skuShowDiscount() {

    $('#product_discount_with_currency_euro').show();
    $('#product_discount_with_currency_yuan').show();
    $('#product_discount').show();

    $('#product_discount').addClass('+discount');
  },

  /**
   * Change the display of the product page sku datas
   */
  skuChangeDisplay: function skuChangeDisplay(productId, skuDatas) {

    ProductsShow.refreshSkuQuantitySelect(productId, skuDatas['quantity']); // productId is useless with the new system (should be refactored)

    $('#product_price_with_currency_yuan').html(skuDatas['price_with_currency_yuan']);
    $('#product_price_with_currency_euro').html(skuDatas['price_with_currency_euro']);
    $('#quantity-left').html(skuDatas['quantity']);

    if (skuDatas['discount'] == 0) {

      ProductsShow.skuHideDiscount();
    } else {

      ProductsShow.skuShowDiscount();

      $('#product_discount_with_currency_euro').html(skuDatas['price_before_discount_in_euro']);
      $('#product_discount_with_currency_yuan').html('<span class="+barred"></span>' + skuDatas['price_before_discount_in_yuan']);
      $('#product_discount').html(skuDatas['discount_with_percent'] + '<br/>');
    }

    ProductsShow.refreshSkuSecondDescription(skuDatas['data']);
    ProductsShow.refreshSkuAttachment(skuDatas['data'], skuDatas['file_attachment']);
    ProductsShow.refreshSkuThumbnailImages(skuDatas['images']);

    ProductsShow.handleProductGalery();
  },

  /**
   * Refresh sku quantity select (quantity dropdown)
   */
  refreshSkuQuantitySelect: function refreshSkuQuantitySelect(productId, quantity) {

    var quantity_select = $('#product_quantity_' + productId).empty();

    for (var i = 1; i <= parseInt(quantity); ++i) {
      quantity_select.append('<option value="' + i + '">' + i + '</option>');
    }
  },

  /**
   * Refresh sku thumbnail images list
   */
  refreshSkuThumbnailImages: function refreshSkuThumbnailImages(images) {

    for (var i = 0; i < images.length; i++) {

      var image = images[i];

      if ($('#thumbnail-' + i).length > 0) {
        $('#thumbnail-' + i).html('<a href="#" data-image="' + image.fullsize + '" data-zoom-image="' + image.zoomin + '"><div class="product-page__thumbnail-image" style="background-image:url(' + image.thumb + ');"></div></a>');
      }
    }
  },

  /**
   * Refresh the sku second description
   */
  refreshSkuSecondDescription: function refreshSkuSecondDescription(secondDescription) {

    console.log('SECD: ' + secondDescription);

    var more = "<h3>" + Translation.find('more', 'title') + "</h3>";

    if (typeof secondDescription !== "undefined") {

      console.log('second description lets go');

      $('#product-file-attachment-and-data').html(more + secondDescription);
    } else {
      $('#product-file-attachment-and-data').html('');
    }
  },

  /**
   * Refresh the sku attachment (depending on second description too)
   */
  refreshSkuAttachment: function refreshSkuAttachment(secondDescription, attachment) {

    var more = "<h3>" + Translation.find('more', 'title') + "</h3>";

    if (typeof attachment !== "undefined") {
      if (typeof secondDescription !== "undefined") {
        $('#product-file-attachment-and-data').html(more + secondDescription);
      }
      $('#product-file-attachment-and-data').append('<br /><a class="btn btn-default" target="_blank" href="' + attachment + '">PDF Documentation</a>');
    }
  }

};

module.exports = ProductsShow;
});

require.register("javascripts/controllers/products/show_skus.js", function(exports, require, module) {
'use strict';

var Translation = require('javascripts/lib/translation');

/**
 * ProductsShowSkus Class
 */
var ProductsShowSkus = {

  /**
   * Initializer
   */
  init: function init() {

    if ($('select.sku-variants-options').length > 0) {

      $('select.sku-variants-options').multiselect({
        nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
        nSelectedText: Translation.find('n_selected_text', 'multiselect'),
        numberDisplayed: 3,
        maxHeight: 400
      }).multiselect('disable');
    }
  }

};

module.exports = ProductsShowSkus;
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

require.register("javascripts/controllers/shops/edit_producer.js", function(exports, require, module) {
'use strict';

/**
 * ShopsEditProducer Class
 */
var ShopsEditProducer = {

  /**
   * Initializer
   */
  init: function init() {

    $(function () {
      $('.edit_producer_submit').click(function () {
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
    });
  }

};

module.exports = ShopsEditProducer;
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

    console.warn("Unable to initialize #js-routes `" + routes.controller + "`.`" + routes.action + "` (" + err + ")");
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
      $(el).fadeOut(function () {
        $(document).trigger('message:hidden'); // To replace footer
      });
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
    //console.log(form);
    form.submit();
  }

};

module.exports = PostForm;
});

require.register("javascripts/lib/translation.js", function(exports, require, module) {
"use strict";

/**
 * Translation Class
 */
var Translation = {

  find: function find(translationSlug, translationScope) {

    var selector = ".js-translation[data-slug='" + translationSlug + "'][data-scope='" + translationScope + "']";
    if ($(selector).length > 0) {
      return $(selector).data('content');
    } else {
      console.error("Translation not found : `" + translationScope + "`.`" + translationSlug + "`");
      return '';
    }
  },

  /**
  * Find a translation and return the string from AJAX with callbacks
  */
  findAsync: function findAsync(translationSlug, translationScope, callback) {

    var TranslationModel = require("javascripts/models/translation");

    TranslationModel.show(translationSlug, translationScope, function (res) {

      if (res.success === false) {
        console.error("Translation not found `" + translationSlug + "` (" + res.error + ")");
      } else {
        callback(res.translation);
      }
    });
  }

};

module.exports = Translation;
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
      url: "/api/guest/order_items/" + orderItemId,
      data: { "quantity": quantity }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = OrderItem;
});

require.register("javascripts/models/product.js", function(exports, require, module) {
"use strict";

/**
 * Product Class
 */
var Product = {

  /**
   * Like a product
   */
  like: function like(productId, callback) {

    $.ajax({
      method: "PUT",
      url: "/api/customer/favorites/" + productId,
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  /**
   * Unlike a product
   */
  unlike: function unlike(productId, callback) {

    $.ajax({
      method: "DELETE",
      url: "/api/customer/favorites/" + productId,
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = Product;
});

require.register("javascripts/models/product_sku.js", function(exports, require, module) {
'use strict';

/**
 * ProductSku Class
 */
var ProductSku = {

  /**
   * Get the ProductSku details
   */
  show: function show(productId, optionIds, callback) {

    $.ajax({

      method: "GET",
      url: '/api/guest/products/' + productId + '/skus/0', // 0 is to match with the norm ... hopefully when we go away from mongo there's no such things
      data: { option_ids: optionIds }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = ProductSku;
});

require.register("javascripts/models/translation.js", function(exports, require, module) {
"use strict";

/**
 * Translations Class
 */
var Translations = {

  /**
   * Get the Translations details
   */
  show: function show(translationSlug, translationScope, callback) {

    $.ajax({

      method: "GET",
      url: '/api/guest/translations/0',
      data: { translation_slug: translationSlug, translation_scope: translationScope }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = Translations;
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
var Starters = ['bootstrap', 'china_city', 'datepicker', 'footer', 'images_control', 'images_handler', 'left_menu', 'messages', 'product_favorite', 'product_form', 'products_list', 'refresh_time', 'responsive', 'search', 'sku_form'];

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

    var self = this;

    if ($('.js-footer-stick').length > 0) {

      Footer.processStickyFooter();

      $(document).on('message:hidden', function () {
        Footer.processStickyFooter();
      });

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

var Translation = require('javascripts/lib/translation');

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

    $("input[class^=img-file-upload]").on('change', function () {

      var Messages = require("javascripts/lib/messages");
      var inputFile = this;

      var maxExceededMessage = Translation.find('max_exceeded_message', 'image_upload');
      var extErrorMessage = Translation.find('ext_error_message', 'image_upload');
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

        Messages.makeError(maxExceededMessage);
        $(inputFile).val('');
      };

      if (extError) {
        Messages.makeError(extErrorMessage);
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

    if ($(".img-file-upload").length > 0) {

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
    }
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

    var self = this;

    $(".js-heart-click").on("click", function (e) {

      e.preventDefault();

      var productId = $(this).attr('data-product-id');
      var favorite = $(this).attr('data-favorite'); // Should be converted

      if (favorite == '1') {

        // We remove the favorite front data
        ProductFavorite.doUnlikeDisplay(this);
        ProductFavorite.doUnlike(productId, function (res) {

          var favoritesCount = res.favorites.length;
          $('#total-likes').html(favoritesCount);
        });
      } else {

        // We change the style before the callback for speed reason
        ProductFavorite.doLikeDisplay(this);
        ProductFavorite.doLike(productId, function (res) {

          var favoritesCount = res.favorites.length;
          $('#total-likes').html(favoritesCount);
        });
      }
    });
  },

  doLike: function doLike(productId, callback) {

    var Product = require("javascripts/models/product");
    var Messages = require("javascripts/lib/messages");

    Product.like(productId, function (res) {

      if (res.success === false) {

        Messages.makeError(res.error);
      } else {

        callback(res);
      }
    });
  },

  doLikeDisplay: function doLikeDisplay(el) {

    $(el).addClass('+red');
    $(el).removeClass('+grey');
    $(el).attr('data-favorite', '1');
  },

  doUnlike: function doUnlike(productId, callback) {

    var Product = require("javascripts/models/product");
    var Messages = require("javascripts/lib/messages");

    Product.unlike(productId, function (res) {

      if (res.success === false) {

        Messages.makeError(res.error);
      } else {

        callback(res);
      }
    });
  },

  doUnlikeDisplay: function doUnlikeDisplay(el) {

    $(el).removeClass('+red');
    $(el).addClass('+grey');
    $(el).attr('data-favorite', '0');
  }
};

module.exports = ProductFavorite;
});

require.register("javascripts/starters/product_form.js", function(exports, require, module) {
"use strict";

var Translation = require('javascripts/lib/translation');

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

      $('select.duty-categories').multiselect({
        nonSelectedText: Translation.find('non_selected_text', 'multiselect'),
        nSelectedText: Translation.find('n_selected_text', 'multiselect'),
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
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

require.register("javascripts/starters/products_list.js", function(exports, require, module) {
"use strict";

/**
 * ProductsList Class
 */
var ProductsList = { // CURRENTLY NOT IN USED IN THE SYSTEM

  /**
   * Initializer
   */
  init: function init() {

    this.manageProductsWall();
  },

  manageProductsWall: function manageProductsWall() {

    /*
          if ($('#freewall-products').length > 0) {
    
            var wall = new freewall("#freewall-products");
    
            wall.reset({
              selector: '.js-brick',
              delay: 0,
              animate: false,
              cellW: 260,
              cellH: 'auto',
              onResize: function() {
                return wall.fitWidth();
              }
            });
    
            wall.container.find('.js-brick img').load(function() {
              $(window).trigger('resize');
            });
    
            $(window).trigger('resize');
    
         }
    */

  }

};

module.exports = ProductsList;
});

require.register("javascripts/starters/refresh_time.js", function(exports, require, module) {
'use strict';

/**
 * RefreshTime Class
 */
var RefreshTime = {

  /**
   * Initializer
   */
  init: function init() {

    this.refreshTime('#utc-time', 'UTC');
    this.refreshTime('#china-time', 'Asia/Shanghai');
    this.refreshTime('#germany-time', 'Europe/Berlin');
  },

  /**
   * Change the current time html
   * @param  {#} selector
   * @return void
   */
  displayTime: function displayTime(selector, time_zone) {
    var time = moment().tz(time_zone).format('HH:mm:ss');
    $(selector).html(time);
  },

  /**
   * Activate the time refresh for specific selector
   * @param  {#} selector
   * @return void
   */
  refreshTime: function refreshTime(selector, time_zone) {
    var remote_time = $(selector).html();
    if (typeof remote_time != "undefined") {
      setInterval(function () {
        RefreshTime.displayTime(selector, time_zone);
      }, 1000);
    }
  }

};

module.exports = RefreshTime;
});

require.register("javascripts/starters/responsive.js", function(exports, require, module) {
"use strict";

/**
 * Responsive Class
 */
var Responsive = { // CURRENTLY NOT IN USED IN THE SYSTEM

  /**
   * Initializer
   */
  init: function init() {

    this.manageCategoriesMenu();
  },

  manageCategoriesMenu: function manageCategoriesMenu() {

    $('#categories-menu').slicknav({

      "prependTo": ".mobile-category-menu" //".container-fluid"

    });
  }

};

module.exports = Responsive;
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

require.register("javascripts/starters/sku_form.js", function(exports, require, module) {
"use strict";

/**
 * ProductsList Class
 */
var SkuForm = { // CURRENTLY NOT IN USED IN THE SYSTEM

    /**
     * Initializer
     */
    init: function init() {

        this.turnUnlimit();
    },

    turnUnlimit: function turnUnlimit() {

        if ($("#js-sku-form").length > 0) {
            var component = $('input[id^=product_skus_attributes_][id$=_unlimited]');

            if (component.is(":checked")) {
                $('input[id^=product_skus_attributes_][id$=quantity]').val(0).prop('disabled', 'true').parent().hide();
            }

            component.change(function () {
                if ($(this).is(":checked")) {
                    $('input[id^=product_skus_attributes_][id$=quantity]').val(0).prop('disabled', 'true').parent().hide();
                } else {
                    $('input[id^=product_skus_attributes_][id$=quantity]').val('').removeAttr('disabled').parent().show();
                }
            });
        }
    }

};

module.exports = SkuForm;
});

require.register("___globals___", function(exports, require, module) {
  
});})();require('___globals___');


//# sourceMappingURL=app.js.map