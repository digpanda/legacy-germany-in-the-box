(function() {
  'use strict';

  var globals = typeof global === 'undefined' ? self : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};
  var aliases = {};
  var has = {}.hasOwnProperty;

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
    var hot = hmr && hmr.createHot(name);
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
    if (bundle && typeof bundle === 'object') {
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
var global = typeof window === 'undefined' ? this : window;
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
require.register("javascripts/controllers/admin/links/index.js", function(exports, require, module) {
'use strict';

/**
* LinksIndex Class
*/
var LinksIndex = {

  /**
  * Initializer
  */
  init: function init() {

    this.handleWechatUrl();
  },

  handleWechatUrl: function handleWechatUrl() {
    $('#wechat-url-adjuster').on('keyup', function (e) {
      var rawUrl = $(this).val();
      LinksIndex.getWechatUrl(rawUrl);
    });
  },

  getWechatUrl: function getWechatUrl(url) {

    var Link = require("javascripts/models/link");
    Link.wechat(url, function (res) {

      if (res.success == true) {
        var endUrl = res.data.adjusted_url;
        $('#wechat-url-adjuster-result').val(endUrl);
      }
    });
  }

};

module.exports = LinksIndex;

});

require.register("javascripts/controllers/admin/shops/package_sets.js", function(exports, require, module) {
'use strict';

/**
* PackageSets Class
*/
var PackageSets = {

  /**
  * Initializer
  */
  init: function init() {

    this.handleSelect();
  },

  handleSelect: function handleSelect() {

    $(document).ready(function () {
      $('select[name*="[product_id]"]').each(function (el) {
        PackageSets.refreshSku(this);
      });
    });

    $('select[name*="[product_id]"]').on('change', function (el) {
      PackageSets.refreshSku(this);
    });
  },

  refreshSku: function refreshSku(self) {

    var productSelector = $(self);
    var ProductSku = require("javascripts/models/product_sku");
    var productId = productSelector.val();

    if (_.isEmpty(productId)) {
      return false;
    }

    ProductSku.all(productId, function (res) {

      if (res.success == true) {

        var skuSelector = productSelector.parent().parent().find('select[name*="[sku_id]"]');
        var possibleSkuId = productSelector.parent().parent().find('.js-sku-id');

        skuSelector.html('<option value="">-</option>');

        res.skus.forEach(function (sku) {

          skuSelector.append("<option value=\"" + sku.id + "\">" + sku.option_names + "</option>");

          // If we are editing we should setup the pre-selected sku id
          var nearSkuId = possibleSkuId.data().skuId;
          skuSelector.val(nearSkuId);
        });
      }
    });
  }

};

module.exports = PackageSets;

});

require.register("javascripts/controllers/admin/shops/products.js", function(exports, require, module) {
'use strict';

/**
 * Products Class
 */
var Products = {

  /**
   * Initializer
   */
  init: function init() {

    this.handleDutyCategoryChange();
  },

  /**
   * We check if the duty category exists through AJAX
   * and throw it / an error on the display
   * @return {void}
   */
  handleDutyCategoryChange: function handleDutyCategoryChange() {

    Products.refreshDutyCategory('#duty-category');

    $('#duty-category').on('keyup', function (e) {

      Products.refreshDutyCategory(this);
    });
  },

  refreshDutyCategory: function refreshDutyCategory(selector) {

    var DutyCategory = require("javascripts/models/duty_category");
    var dutyCategoryId = $(selector).val();

    if (dutyCategoryId === '' || typeof dutyCategoryId == "undefined") {
      return;
    }

    DutyCategory.find(dutyCategoryId, function (res) {

      if (res.success) {
        Products.showDutyCategory(res.datas.duty_category);
      } else {
        Products.throwNotFoundDutyCategory();
      }
    });
  },

  showDutyCategory: function showDutyCategory(duty_category) {

    $('.js-duty-category').html('<span class="+blue">' + duty_category.name + '</span>');
  },

  throwNotFoundDutyCategory: function throwNotFoundDutyCategory() {

    $('.js-duty-category').html('<span class="+red">Duty Category not found</span>');
  }

};

module.exports = Products;

});

require.register("javascripts/controllers/admin/shops/products/skus.js", function(exports, require, module) {
"use strict";

/**
 * ProductsSkus Class
 */
var ProductsSkus = {

  /**
   * Initializer
   */
  init: function init() {

    /**
     * Since the system is cloned on the admin we try
     * to limit the code duplication by abstracting into a library
     */
    var Skus = require("javascripts/lib/skus");
    Skus.setup();
  }

};

module.exports = ProductsSkus;

});

require.register("javascripts/controllers/admin/shops/products/variants.js", function(exports, require, module) {
"use strict";

/**
 * ProductsVariants Class
 */
var ProductsVariants = {

  /**
   * Initializer
   */
  init: function init() {

    /**
     * Since the system is cloned on the admin we try
     * to limit the code duplication by abstracting into a library
     */
    var Variants = require("javascripts/lib/variants");
    Variants.setup();
  }

};

module.exports = ProductsVariants;

});

require.register("javascripts/controllers/customer/cart/show.js", function(exports, require, module) {
'use strict';

var RefreshTotalProducts = require('javascripts/services/refresh_total_products');
var Messages = require("javascripts/lib/messages");

/**
 * Cart class
 */
var Cart = {

  clickChain: 0, // init click chain system
  chainTiming: 500, // in ms

  /**
   * Initializer
   */
  init: function init() {

    this.orderItemHandleQuantity();
    this.removeOrderItem();
    this.removePackageSet();
    this.handleCouponAutoApply();
  },

  handleCouponAutoApply: function handleCouponAutoApply() {
    var original_href = $('#checkout-button').attr('href');
    $('#coupon_code').on('keyup', function (e) {
      var target = e.currentTarget;
      var coupon = target.value;
      var new_href = original_href + "?coupon=" + coupon;
      $('#checkout-button').attr('href', new_href);
    });
  },

  getItemData: function getItemData(el) {
    return {
      orderId: $(el).data('orderId'),
      orderItemId: $(el).data('orderItemId'),
      orderShopId: $(el).data('orderShopId'),
      originQuantity: parseInt($('#order-item-quantity-' + $(el).data('orderItemId')).html()),
      originTotal: $('#order-item-total-' + $(el).data('orderItemId')).attr('data-origin')
    };
  },

  getSelectors: function getSelectors(itemData) {
    return {
      item: $('#order-item-' + itemData.orderItemId),
      order: $('#order-' + itemData.orderId)
    };
  },

  removeItem: function removeItem(e) {
    e.preventDefault();

    var OrderItem = require("javascripts/models/order_item");
    var itemData = Cart.getItemData(this);

    OrderItem.removeProduct(itemData.orderItemId, function (res) {

      var selectors = Cart.getSelectors(itemData);

      if (res.success === true) {

        selectors.item.remove();

        // If the order itself is empty
        // We remove it as well
        if (res.order_empty == true) {
          selectors.order.remove();
        }

        RefreshTotalProducts.perform();
        Cart.resetTotalDisplay(itemData.orderShopId, res);
      } else {

        Messages.makeError(res.error);
      }
    });
  },

  increaseQuantity: function increaseQuantity(e) {
    e.preventDefault();
    var itemData = Cart.getItemData(this);
    var currentQuantity = itemData.originQuantity + 1;
    Cart.clickChain++;
    Cart.orderItemSetQuantity(itemData, currentQuantity);
  },

  decreaseQuantity: function decreaseQuantity(e) {
    e.preventDefault();
    var itemData = Cart.getItemData(this);
    var currentQuantity = itemData.originQuantity;
    if (itemData.originQuantity > 1) {
      currentQuantity--;
    }
    if (itemData.originQuantity != currentQuantity) {
      Cart.clickChain++;
      Cart.orderItemSetQuantity(itemData, currentQuantity);
    }
  },

  orderItemHandleQuantity: function orderItemHandleQuantity() {

    $('.js-set-quantity-minus').on('click', Cart.decreaseQuantity);
    $('.js-set-quantity-plus').on('click', Cart.increaseQuantity);

    $('.js-set-package-quantity-minus').click(function (e) {

      e.preventDefault();
      Cart.clickChain++;

      var packageSetId = $(this).data('package-set-id');
      var currentQuantity = $('#package-quantity-' + packageSetId).html();
      var currentTotal = $('#package-total-' + packageSetId).attr('data-origin');
      var orderShopId = $(this).data('order-shop-id');
      var originQuantity = currentQuantity;
      var originTotal = currentTotal;

      if (currentQuantity > 1) {
        currentQuantity--;
      }

      if (originQuantity != currentQuantity) {
        Cart.clickChain++;
        Cart.packageSetSetQuantity(packageSetId, originQuantity, originTotal, currentQuantity, orderShopId);
      }
    });

    $('.js-set-package-quantity-plus').click(function (e) {

      e.preventDefault();
      Cart.clickChain++;

      var packageSetId = $(this).data('package-set-id');
      var currentQuantity = $('#package-quantity-' + packageSetId).html();
      var currentTotal = $('#package-total-' + packageSetId).attr('data-origin');
      var orderShopId = $(this).data('order-shop-id');
      var originQuantity = currentQuantity;
      var originTotal = currentTotal;

      currentQuantity++;
      Cart.packageSetSetQuantity(packageSetId, originQuantity, originTotal, currentQuantity, orderShopId);
    });
  },

  setItemLoading: function setItemLoading(itemData, currentQuantity) {
    // We first setup a temporary number before the AJAX callback
    $('#order-item-quantity-' + itemData.orderItemId).html(currentQuantity);
    $('#order-item-total-' + itemData.orderItemId).html('-');
  },

  orderItemSetQuantity: function orderItemSetQuantity(itemData, currentQuantity) {

    Cart.setItemLoading(itemData, currentQuantity);
    var currentClickChain = Cart.clickChain;

    setTimeout(function () {
      // We basically prevent multiple click by considering only the last click as effective
      // It won't call the API if we clicked more than once on the + / - within the second
      if (currentClickChain == Cart.clickChain) {
        Cart.processQuantity(itemData, currentQuantity);
      }
    }, Cart.chainTiming);
  },

  packageSetSetQuantity: function packageSetSetQuantity(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId) {

    // We first setup a temporary number before the AJAX callback
    $('#package-quantity-' + packageSetId).html(packageSetQuantity);
    $('#package-total-' + packageSetId).html('-');

    var currentClickChain = Cart.clickChain;

    setTimeout(function () {

      // We basically prevent multiple click by considering only the last click as effective
      // It won't call the API if we clicked more than once on the + / - within the second
      if (currentClickChain == Cart.clickChain) {
        Cart.processPackageSetQuantity(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId);
      }
    }, Cart.chainTiming);
  },

  removeOrderItem: function removeOrderItem() {

    $('.delete-order-item').on('click', Cart.removeItem);
  },

  removePackageSet: function removePackageSet() {

    $('.delete-package-set').on('click', function (e) {

      e.preventDefault();

      // CartModel named this way because of collision because not well abstracted
      // we should keep refactor this shit.
      var CartModel = require("javascripts/models/cart");
      var orderId = $(this).data('order-id');
      var packageSetId = $(this).data('package-set-id');
      var orderShopId = $(this).data('order-shop-id');

      CartModel.removePackageSet(packageSetId, orderId, function (res) {

        if (res.success === true) {

          $('#package-set-' + packageSetId).remove();

          if (res.order_empty == true) {
            $('#order-' + orderId).remove();
          }

          RefreshTotalProducts.perform();
          Cart.resetTotalDisplay(orderShopId, res);
        } else {

          Messages.makeError(res.error);
        }
      });
    });
  },

  processQuantity: function processQuantity(itemData, currentQuantity) {

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setQuantity(itemData.orderItemId, currentQuantity, function (res) {

      if (res.success === false) {

        Cart.rollbackQuantity(itemData.originQuantity, itemData.originTotal, itemData.orderItemId, res);
        Messages.makeError(res.error);
      } else {

        // We first refresh the value in the HTML
        Cart.resetHeaderCartQuantity();
        Cart.resetDisplay(currentQuantity, itemData.orderItemId, itemData.orderShopId, res);

        var refreshTotalProducts = require('javascripts/services/refresh_total_products');
        refreshTotalProducts.perform();
      }
    });
  },

  processPackageSetQuantity: function processPackageSetQuantity(packageSetId, originQuantity, originTotal, packageSetQuantity, orderShopId) {

    var OrderItem = require("javascripts/models/order_item");
    OrderItem.setPackageSetQuantity(packageSetId, packageSetQuantity, function (res) {

      if (res.success === false) {

        Cart.rollbackPackageSetQuantity(originQuantity, originTotal, packageSetId, res);
        Messages.makeError(res.error);
      } else {

        // We first refresh the value in the HTML
        Cart.resetPackageDisplay(packageSetQuantity, packageSetId, orderShopId, res);

        var refreshTotalProducts = require('javascripts/services/refresh_total_products');
        refreshTotalProducts.perform();
      }
    });
  },

  resetHeaderCartQuantity: function resetHeaderCartQuantity() {

    /**
     * NOTE : This system was cancelled because we don't show
     * the number of product within the cart
     * - Laurent, 23/01/2017
     */
    // var total = 0;
    //
    // $('[id^="order-item-quantity-"]').each(function(e) {
    //   total += parseInt($(this).val());
    //   $('#total-products').html(total);
    // })

  },

  rollbackQuantity: function rollbackQuantity(originQuantity, originTotal, orderItemId, res) {

    // TODO : possible improvement
    // instead of rolling back completely we could make a system
    // to try again with different quantity

    // We try to get back the correct value from AJAX if we can
    // To avoid the system to show a wrong quantity on the display
    if (typeof res.original_quantity != "undefined" && typeof res.original_total != "undefined") {
      originQuantity = res.original_quantity;
      originTotal = res.original_total;
    }

    // We rollback the quantity
    $('#order-item-quantity-' + orderItemId).html(originQuantity);
    $('#order-item-total-' + orderItemId).html(originTotal);
  },

  rollbackPackageSetQuantity: function rollbackPackageSetQuantity(originQuantity, originTotal, packageSetId, res) {

    if (typeof res.original_quantity != "undefined" && typeof res.original_total != "undefined") {
      originQuantity = res.original_quantity;
      originTotal = res.original_total;
    }

    // We rollback the quantity
    $('#package-quantity-' + packageSetId).html(originQuantity);
    $('#package-total-' + packageSetId).html(originTotal);
  },

  resetDisplay: function resetDisplay(orderItemQuantity, orderItemId, orderShopId, res) {

    // Quantity changes
    $('#order-item-quantity-' + orderItemId).html(orderItemQuantity);
    $('#order-item-total-' + orderItemId).html(res.data.order_item.total_price_with_taxes);
    $('#order-item-total-' + orderItemId).attr('data-origin', res.data.order_item.total_price_with_taxes);

    Cart.resetTotalDisplay(orderShopId, res);
  },

  resetPackageDisplay: function resetPackageDisplay(packageSetQuantity, packageSetId, orderShopId, res) {

    // Quantity changes
    $('#package-quantity-' + packageSetId).html(packageSetQuantity);
    $('#package-total-' + packageSetId).html(res.data.package_set.total_price);
    $('#package-total-' + packageSetId).attr('data-origin', res.data.package_set.total_price);

    Cart.resetTotalDisplay(orderShopId, res);
  },

  resetTotalDisplay: function resetTotalDisplay(orderShopId, res) {

    // Total changes
    $('#order-total-price-with-taxes-' + orderShopId).html(res.data.total_price_with_taxes);
    $('#order-shipping-cost-' + orderShopId).html(res.data.shipping_cost);
    $('#order-end-price-' + orderShopId).html(res.data.end_price);

    // Discount management
    if (typeof res.data.total_price_with_discount != "undefined") {
      $('#order-total-price-with-extra-costs-' + orderShopId).html(res.data.total_price_with_extra_costs);
      $('#order-total-price-with-discount-' + orderShopId).html(res.data.total_price_with_discount);
      $('#order-discount-display-' + orderShopId).html(res.data.discount_display);
    }
  }

};

module.exports = Cart;

});

require.register("javascripts/controllers/customer/checkout/gateway.js", function(exports, require, module) {
"use strict";

/**
 * CustomerGatewayCreate class
 */
var CustomerGatewayCreate = {

  /**
   * Initializer
   */
  init: function init() {

    this.postBankDetails();

    // We will check the order payment every once in a while
    setInterval(this.orderPaymentLiveRefresh, 3000);
  },

  /**
   * We refresh the page according to the order payment status
   */
  orderPaymentLiveRefresh: function orderPaymentLiveRefresh() {

    // If it's Wechatpay from Desktop and it needs auto refresh
    if ($("#order-payment-live-refresh").length > 0) {

      var OrderPayment = require("javascripts/models/order_payment");
      var orderPaymentId = $('#order-payment-live-refresh').data('order-payment-id');

      OrderPayment.show(orderPaymentId, function (res) {

        if (res.success === true) {

          // We can check the order payment status
          switch (res.order_payment.status) {
            case "scheduled":
              break;
            case "unverified":
              // Unverified means an action has been done but is awaiting approval; it's like a success.
              window.location.href = $("#order-payment-callback-url").data('success');
              break;
            case 'success':
              window.location.href = $("#order-payment-callback-url").data('success');
              break;
            case "failed":
              window.location.href = $("#order-payment-callback-url").data("fail");
              break;
            default:
              break;
          }
        } else {

          Messages.makeError(res.error);
        }
      });
    }
  },

  /**
   * Post bank details to the `form_url`
   */
  postBankDetails: function postBankDetails() {

    // If it's Wirecard
    if ($("#bank-details").length > 0) {

      var Casing = require("javascripts/lib/casing");
      var PostForm = require("javascripts/lib/post_form.js");

      var bankDetails = $("#bank-details")[0].dataset;
      var parsedBankDetails = Casing.objectToUnderscoreCase(bankDetails);

      PostForm.send(parsedBankDetails, parsedBankDetails['form_url']);
    }
  }

};

module.exports = CustomerGatewayCreate;

});

require.register("javascripts/controllers/customer/checkout/payment_method.js", function(exports, require, module) {
"use strict";

/**
 * CustomerCheckoutPaymentMethod class
 */
var CustomerCheckoutPaymentMethod = {

  /**
   * Initializer
   */
  init: function init() {

    this.handleMethodSelection();
    this.handleSpecialInstructions();
    var CustomerCartShow = require("javascripts/controllers/customer/cart/show");
  },

  handleSpecialInstructions: function handleSpecialInstructions() {

    var Order = require("javascripts/models/order");

    $('#special_instructions').on('keyup', function (e) {

      var orderId = $(this).data('orderId');
      var params = { 'special_instructions': $(this).val() };
      Order.update(orderId, params, function (res) {
        // nothing
      });
    });
  },

  /**
   * Will process after someone click to go through the payment gateway (blank page)
   */
  handleMethodSelection: function handleMethodSelection() {

    $('#payment_method_area').find('a').click(function (e) {

      $('#payment_method_area').hide();
      $('#after_payment_method_area').removeClass('+hidden');
    });
  }

};

module.exports = CustomerCheckoutPaymentMethod;

});

require.register("javascripts/controllers/customer/orders/addresses.js", function(exports, require, module) {
'use strict';

/**
 * OrdersAddresses class
 */
var OrdersAddresses = {

  /**
   * Initializer
   */
  init: function init() {

    this.newAddressForm();
  },

  /**
   * When someone clicks on "enter new address" a form will show up
   */
  newAddressForm: function newAddressForm() {

    $('#button-new-address').on('click', function (e) {

      $('#button-new-address').addClass('+hidden');
      $('#new-address').removeClass('+hidden');

      OrdersAddresses.scrollToForm();

      // we reset the sticky footer because it makes useless spaces
      var Footer = require('javascripts/starters/footer');
      Footer.processStickyFooter();
    });
  },

  scrollToForm: function scrollToForm() {
    $('html, body').animate({
      scrollTop: $("#new-address").offset().top
    }, 500);
  }

};

module.exports = OrdersAddresses;

});

require.register("javascripts/controllers/customer/orders/show.js", function(exports, require, module) {
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

require.register("javascripts/controllers/customer/referrer/links/share.js", function(exports, require, module) {
"use strict";

/**
 * Share Class
 */
var Share = {

  /**
   * Initializer
   */
  init: function init() {}

};

module.exports = Share;

});

require.register("javascripts/controllers/customer/referrer/provision.js", function(exports, require, module) {
'use strict';

/**
 * Provision class
 */
var Provision = {

  /**
   * Initializer
   */
  init: function init() {

    this.handleDetailTables();
  },

  handleDetailTables: function handleDetailTables() {
    $('#click-detail-tables').on('click', this.clickDetailTables);
  },

  clickDetailTables: function clickDetailTables(e) {
    e.preventDefault();
    $('#detail-tables').show();
    $('#click-detail-tables').hide();
  }

};

module.exports = Provision;

});

require.register("javascripts/controllers/guest/feedback.js", function(exports, require, module) {
'use strict';

/**
 * GuestFeedback Class
 */
var GuestFeedback = {

  /**
   * Initializer
   */
  init: function init() {

    var Preloader = require("javascripts/lib/preloader");
    Preloader.dispatchLoader('#external-script', '.js-loader', 'iframe#WJ_survey');
  }

};

module.exports = GuestFeedback;

});

require.register("javascripts/controllers/guest/home/weixin.js", function(exports, require, module) {
"use strict";

/**
 * GuestHomeWeixin Class
 */
var GuestHomeWeixin = {

  /**
   * Initializer
   */
  init: function init() {

    window.location.assign("weixin://wechat.com/");
  }

};

module.exports = GuestHomeWeixin;

});

require.register("javascripts/controllers/guest/package_sets.js", function(exports, require, module) {
'use strict';

var Translation = require("javascripts/lib/translation");
/**
 * PackageSets Class
 */
var PackageSetsShow = {

    /**
     * Initializer
     */
    init: function init() {

        this.manageAddPackageSet();
    },

    manageAddPackageSet: function manageAddPackageSet() {

        $('.js-add-package-set').on('click', function (e) {

            e.preventDefault();

            var OrderItem = require("javascripts/models/order_item");
            var packageSetId = $(this).data('package-set-id');
            console.log(packageSetId);

            OrderItem.addPackageSet(packageSetId, function (res) {

                var Messages = require("javascripts/lib/messages");

                if (res.success === true) {

                    Messages.makeSuccess(res.message);

                    var refreshTotalProducts = require('javascripts/services/refresh_total_products');
                    refreshTotalProducts.perform();
                } else {

                    Messages.makeError(res.error);
                }
            });
        });
    }
};

module.exports = PackageSetsShow;

});

require.register("javascripts/controllers/guest/products/show.js", function(exports, require, module) {
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
    this.handleQuantityChange();
    this.handleAddSku();
  },

  /**
   * Grow or reduce price on the display
   * @param  {String} [option] `grow` or `reduce` price
   * @param  {Integer} old_quantity    the original old quantity
   * @param  {String} selector        the area the HTML had to be changed
   * @return {void}
   */
  changePrice: function changePrice() {
    var option = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 'grow';
    var old_quantity = arguments[1];
    var selector = arguments[2];


    if (typeof $(selector) == 'undefined') {
      return;
    }

    old_quantity = parseInt(old_quantity);
    var old_price = $(selector).html();
    var unit_price = parseFloat(old_price) / parseInt(old_quantity);

    if (option == 'grow') {
      var new_quantity = old_quantity + 1;
    } else if (option == 'reduce') {
      var new_quantity = old_quantity - 1;
    }

    var new_price = unit_price * new_quantity;
    $(selector).html(new_price.toFixed(2));
  },

  /**
   * Handle the quantity change with different selector (minus or plus)
   * @return {void}
   */
  handleQuantityChange: function handleQuantityChange() {

    this.manageQuantityMinus();
    this.manageQuantityPlus();
  },

  /**
   * Reduce the quantity by clicking on the minus symbol on the page
   * @return {void}
   */
  manageQuantityMinus: function manageQuantityMinus() {

    $('#quantity-minus').on('click', function (e) {

      e.preventDefault();
      var quantity = $('#quantity').val();;

      if (quantity > 1) {

        ProductsShow.changePrice('reduce', quantity, '#product_discount_with_currency_yuan .amount');
        ProductsShow.changePrice('reduce', quantity, '#product_discount_with_currency_euro .amount');

        // We show per unit
        //ProductsShow.changePrice('reduce', quantity, '#product_fees_with_currency_yuan .amount');

        ProductsShow.changePrice('reduce', quantity, '#product_price_with_currency_yuan .amount');
        ProductsShow.changePrice('reduce', quantity, '#product_price_with_currency_euro .amount');
        quantity--;
      }
      $('#quantity').val(quantity);
    });
  },

  /**
   * Grow the quantity by clicking on the plus symbol on the page
   * @return {void}
   */
  manageQuantityPlus: function manageQuantityPlus() {

    $('#quantity-plus').on('click', function (e) {

      e.preventDefault();
      var quantity = $('#quantity').val();

      if (quantity < $('#quantity').data('max')) {

        ProductsShow.changePrice('grow', quantity, '#product_discount_with_currency_yuan .amount');
        ProductsShow.changePrice('grow', quantity, '#product_discount_with_currency_euro .amount');

        // We show per unit only because it's not growable accurately
        //ProductsShow.changePrice('grow', quantity, '#product_fees_with_currency_yuan .amount');
        ProductsShow.changePrice('grow', quantity, '#product_price_with_currency_yuan .amount');
        ProductsShow.changePrice('grow', quantity, '#product_price_with_currency_euro .amount');
        quantity++;
      }
      $('#quantity').val(quantity);
    });
  },

  /**
   * Adds the product to the cart when clicking on 'Add Product'
   * @return {void}
   */

  handleAddSku: function handleAddSku() {

    $('#js-add-to-cart').on('click', function (e) {

      e.preventDefault();

      var OrderItem = require("javascripts/models/order_item");

      var quantity = $('#quantity').val();
      var skuId = $('#sku_id').val();
      var productId = $('#sku_id').data('productId');

      OrderItem.addSku(productId, skuId, quantity, function (res) {

        var Messages = require("javascripts/lib/messages");

        if (res.success === true) {

          Messages.makeSuccess(res.message);

          var refreshTotalProducts = require('javascripts/services/refresh_total_products');
          refreshTotalProducts.perform();
        } else {

          Messages.makeError(res.error);
        }
      });
    });
  },

  /**
   * Manage the whole gallery selection
   * @return {void}
   */
  handleProductGalery: function handleProductGalery() {

    $(document).on('click', '#gallery a', function (e) {

      var image = $(this).data('image');
      var zoomImage = $(this).data('zoom-image');

      e.preventDefault();

      // Changing the image when we click on any thumbnail of the #gallery
      // We also manage a small pre-loader in case it's slow.
      ProductsShow.changeMainImage(image, '.js-loader');

      /*
      $('#main_image').magnify({
        speed: 0,
        src: zoomImage,
      });*/
    });

    // We don't forget to trigger the click to load the first image
    $('#gallery a:first').trigger('click');

    // We hide the button because
    // if there's only one element
    ProductsShow.manageClickableImages();
  },

  /**
   * Hide the thumbnail clickables images of the gallery
   * If not needed (such as one image total)
   * @return {void}
   */
  manageClickableImages: function manageClickableImages() {

    if ($('#gallery a').size() <= 1) {
      $('#gallery a:first').hide();
    }
  },

  /**
   * Load a new main image from a thumbanil
   * @param  {String} image new image source
   * @param  {String} loader_selector loader to display
   * @return {void}
   */
  changeMainImage: function changeMainImage(image, loader_selector) {

    var ContentPreloader = require("javascripts/lib/content_preloader");
    ContentPreloader.process($('#main_image').attr('src', image), loader_selector);
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

    $('#product_fees_with_currency_yuan').html(skuDatas['fees_with_currency_yuan']);
    $('#product_price_with_currency_yuan').html(skuDatas['price_with_currency_yuan']);
    $('#product_price_with_currency_euro').html(skuDatas['price_with_currency_euro']);
    $('#quantity-left').html(skuDatas['quantity']);

    $('#quantity').val(1); // we reset the quantity to 1

    if (skuDatas['discount'] == 0) {

      ProductsShow.skuHideDiscount();
    } else {

      ProductsShow.skuShowDiscount();

      $('#product_discount_with_currency_euro').html('<span class="+barred"><span class="+dark-grey">' + skuDatas['price_before_discount_in_euro'] + '</span></span>');
      $('#product_discount_with_currency_yuan').html('<span class="+barred"><span class="+black">' + skuDatas['price_before_discount_in_yuan'] + '</span></span>');
      $('#product_discount').html(skuDatas['discount_with_percent'] + '<br/>');
    }

    ProductsShow.refreshSkuSecondDescription(skuDatas['data_format']);

    ProductsShow.refreshSkuAttachment(skuDatas['data_format'], skuDatas['file_attachment']);
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

    $('#gallery').empty();
    for (var i = 0; i < images.length; i++) {

      var image = images[i];

      // protection to avoid empty images
      // in case of transfer bug to the front-end
      if (image.fullsize != null) {

        $('#gallery').append('<div id="thumbnail-' + i + '" class="col-md-2 col-xs-4 +centered">' + '<a href="#" data-image="' + image.fullsize + '" data-zoom-image="' + image.zoomin + '"><div class="product-page__thumbnail-image" style="background-image:url(' + image.thumb + ');"></div></a>' + '</div>');
      }
    }
  },

  /**
   * Refresh the sku second description
   */
  refreshSkuSecondDescription: function refreshSkuSecondDescription(secondDescription) {

    var more = "<h3>" + Translation.find('more', 'title') + "</h3>";

    if (typeof secondDescription !== "undefined") {
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

require.register("javascripts/controllers/shopkeeper/products/skus.js", function(exports, require, module) {
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

    /**
     * TODO: THIS SEEMS TO BE HIGHLY DEPRECATED BUT WE SHOULD MAKE SURE IT IS BEFORZ TO REMOVE
     */

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

      $('input.img-file-upload').click(function () {
        if ($('img.img-responsive[src=""]').length > 0) {
          $('.fileUpload').removeClass('invalidBorderClass');
        }
      });

      return true;
    });
  }

};

module.exports = ProductNewSku;

});

require.register("javascripts/controllers/shopkeeper/products/skus/index.js", function(exports, require, module) {
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

require.register("javascripts/controllers/shopkeeper/products/variants.js", function(exports, require, module) {
"use strict";

/**
 * ProductsVariants Class
 */
var ProductsVariants = {

  /**
   * Initializer
   */
  init: function init() {

    /**
     * Since the system is cloned on the admin we try
     * to limit the code duplication by abstracting into a library
     */
    var Variants = require("javascripts/lib/variants");
    Variants.setup();
  }

};

module.exports = ProductsVariants;

});

require.register("javascripts/initialize.js", function(exports, require, module) {
"use strict";

$(document).ready(function () {

  /**
   * Controllers loader by Loschcode
   * Damn simple class loader.
   */
  var routes = $("#js-routes").data();
  var info = $("#js-info").data();
  var starters = require("javascripts/starters");

  /**
   * Disable console.log for production and tests (poltergeist)
   */
  if (info.environment == "production" || info.environment == "test") {
    // || (info.environment == "test")
    if (typeof window.console != "undefined") {
      window.console = {};
      window.console.log = function () {};
      window.console.info = function () {};
      window.console.warn = function () {};
      window.console.error = function () {};
    }
  }

  try {

    var Casing = require("javascripts/lib/casing");

    for (var idx in starters) {

      if (info.environment != "test") {
        console.info('Loading starter : ' + starters[idx]);
      }

      var formatted_starter = Casing.underscoreCase(starters[idx]).replace('-', '_');
      var _obj = require("javascripts/starters/" + formatted_starter);
      _obj.init();
    }
  } catch (err) {

    console.error("Unable to initialize #js-starters (" + err + ")");
    return;
  }

  try {
    var meta_obj = require("javascripts/controllers/" + routes.controller);
    console.info("Loading controller " + routes.controller);
    meta_obj.init();
  } catch (err) {
    console.warn("Unable to initialize #js-routes `" + routes.controller + "` (" + err + ")");
  }

  try {
    var obj = require("javascripts/controllers/" + routes.controller + "/" + routes.action);
    console.info("Loading controller-action " + routes.controller + "/" + routes.action);
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
    }).replace(/^_/, "").replace('-', '_');
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

require.register("javascripts/lib/content_preloader.js", function(exports, require, module) {
"use strict";

/**
 * ContentPreloader Class
 */
var ContentPreloader = {

  /**
   * Preload some content inside the system
   * @param  {String} image new image source
   * @param  {String} loader_selector loader to display
   * @return {void}
   */
  process: function process(selected_attr, loader_selector) {

    selected_attr.load(function () {
      $(loader_selector).hide();
      $(this).show();
    }).before(function () {
      $(loader_selector).show();
      $(this).hide();
    });
  }

};

module.exports = ContentPreloader;

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

  datepicker.regional['zh-CN'] = {
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
  datepicker.setDefaults(datepicker.regional['zh-CN']);

  return datepicker.regional['zh-CN'];
});

});

require.register("javascripts/lib/messages.js", function(exports, require, module) {
'use strict';

/**
 * Messages Class
 */
var Messages = {

  shown: false,

  makeError: function makeError(error) {

    $('#message-container-error').show();
    $("#message-content-error").html(error);
    Messages.activateHide('#message-container-error', 3000);
    Messages.shown = true;
  },

  makeSuccess: function makeSuccess(success) {

    $('#message-container-success').show();
    $("#message-content-success").html(success);
    Messages.activateHide('#message-container-success', 4000);
    Messages.shown = true;
  },

  /**
   * Everything below is called from the starter messages.js
   */

  activateHide: function activateHide(el, time) {

    setTimeout(function () {
      $(el).fadeOut(function () {
        $(document).trigger('message:hidden');
        Messages.shown = false;
      });
    }, time);
  },

  forceHide: function forceHide(el) {
    $('#message-area').on('click', function () {
      $(el).hide();
    });
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

require.register("javascripts/lib/preloader.js", function(exports, require, module) {
"use strict";

/**
* Preloader Class
*/
var Preloader = {

  /**
  * Check an element and hide it until the trigger is loaded itself
  * Show a loder `.js-loader` if possible
  */
  dispatchLoader: function dispatchLoader(element, loader_selector, trigger) {

    $(loader_selector).show();
    $(element).hide();

    $(trigger).load(function () {
      $(loader_selector).hide();
      $(element).show();
    });
  }

};

module.exports = Preloader;

});

require.register("javascripts/lib/skus.js", function(exports, require, module) {
'use strict';

/**
 * Skus Class
 */
var Skus = {

  setup: function setup() {

    this.handleMultiSelect();
    this.handleForm();
  },

  /**
   * We turn the multi-select of the sku dashboard management into a readable checkbox select
   * @return {void}
   */
  handleMultiSelect: function handleMultiSelect() {

    var Translation = require('javascripts/lib/translation');

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
  },

  /**
   * This seems to handle the images warning on the skus form for shopkeeper and admin
   * NOTE : i didn't refactor this, it should be made cleaner and check the use.
   */
  handleForm: function handleForm() {

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

      $('input.img-file-upload').click(function () {
        if ($('img.img-responsive[src=""]').length > 0) {
          $('.fileUpload').removeClass('invalidBorderClass');
        }
      });

      return true;
    });
  }

};

module.exports = Skus;

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

require.register("javascripts/lib/url_process.js", function(exports, require, module) {
'use strict';

/**
 * UrlProcess Class
 */
var UrlProcess = {

    urlParam: function urlParam(param) {
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

    insertParam: function insertParam(key, value) {

        key = encodeURI(key);value = encodeURI(value);

        var kvp = document.location.search.substr(1).split('&');

        var i = kvp.length;var x;while (i--) {
            x = kvp[i].split('=');

            if (x[0] == key) {
                x[1] = value;
                kvp[i] = x.join('=');
                break;
            }
        }

        if (i < 0) {
            kvp[kvp.length] = [key, value].join('=');
        }

        //this will reload the page, it's likely better to store this until finished
        document.location.search = kvp.join('&');
    }

};

module.exports = UrlProcess;

});

require.register("javascripts/lib/variants.js", function(exports, require, module) {
'use strict';

/**
 * Variants Class
 */
var Variants = {

  setup: function setup() {

    this.addOptionHandler();
    this.removeOptionHandler();

    this.addVariantHandler();
    this.removeVariantHandler();
  },

  addVariantHandler: function addVariantHandler() {

    $('#add-variant').on('click', function (e) {

      e.preventDefault();
      var target = $('.js-temporary-variant.hidden:first');
      console.log(target);
      target.removeClass('hidden');
    });
  },

  removeVariantHandler: function removeVariantHandler() {

    $('.js-remove-variant').on('click', function (e) {

      e.preventDefault();
      var container = $(this).closest('.js-temporary-variant');
      var input_target = container.find('input');
      input_target.val('');
      container.addClass('hidden');
    });
  },

  /**
   * We add an option (aka suboption in some cases) to the variant
   * It will just show a field which was previously hidden
   * NOTE : everything is managed by rails itself beforehand
   * to make it flexible in the front-end side
   */
  addOptionHandler: function addOptionHandler() {

    $('.js-add-option').on('click', function (e) {

      e.preventDefault();
      var target = $(this).closest('.variant-box').find('.js-temporary-option.hidden:first');
      target.removeClass('hidden');
    });
  },

  /**
   * Set the value of the field to empty
   * and hide it from the display
   */
  removeOptionHandler: function removeOptionHandler() {

    $('.js-remove-option').on('click', function (e) {

      e.preventDefault();
      var container = $(this).closest('.js-temporary-option');
      var input_target = container.find('input');
      input_target.val('');
      container.addClass('hidden');
    });
  }

};

module.exports = Variants;

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

require.register("javascripts/models/cart.js", function(exports, require, module) {
"use strict";

/**
 * Cart Class
 */
var Cart = {

  /**
   * Get the total number of products within the cart
   */
  total: function total(callback) {

    // NOTE : condition race made it impossible to build
    // I passed 2 full days on this problem
    // Good luck.
    // - Laurent
    $.ajax({
      method: "GET",
      url: "/api/guest/cart/total",
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  removePackageSet: function removePackageSet(packageSetId, orderId, callback) {

    $.ajax({
      method: "DELETE",
      url: "/api/guest/package_sets/" + packageSetId,
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = Cart;

});

require.register("javascripts/models/chart.js", function(exports, require, module) {
"use strict";

/**
 * Chart Class
 */
var Chart = {

  /**
   * Get the total number of products within the cart
   */
  get: function get(action, metadata, callback) {

    console.log("/api/admin/charts/" + action);
    // NOTE : condition race made it impossible to build
    // I passed 2 full days on this problem
    // Good luck.
    // - Laurent
    $.ajax({
      method: "GET",
      url: "/api/admin/charts/" + action,
      data: { metadata: metadata || {} }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = Chart;

});

require.register("javascripts/models/duty_category.js", function(exports, require, module) {
"use strict";

/**
 * Duty Category Class
 */
var DutyCategory = {

  /**
   * Check if user is auth or not via API call
   */
  find: function find(dutyCategoryId, callback) {

    $.ajax({
      method: "GET",
      url: "/api/admin/duty_categories/" + dutyCategoryId,
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = DutyCategory;

});

require.register("javascripts/models/link.js", function(exports, require, module) {
"use strict";

/**
 * Link Class
 */
var Link = {

  /**
   * Get the total number of products within the cart
   */
  wechat: function wechat(raw_url, callback) {

    // NOTE : condition race made it impossible to build
    // I passed 2 full days on this problem
    // Good luck.
    // - Laurent
    $.ajax({
      method: "GET",
      url: "/api/admin/links/wechat",
      data: { raw_url: raw_url }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = Link;

});

require.register("javascripts/models/navigation_model.js", function(exports, require, module) {
"use strict";

/**
 * NavigationModel Class
 */
var NavigationModel = {

  /**
   * Check if user is auth or not via API call
   */
  setLocation: function setLocation(location, callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/guest/navigation/",
      data: { "location": location }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = NavigationModel;

});

require.register("javascripts/models/order.js", function(exports, require, module) {
"use strict";

/**
 * Order Class
 */
var Order = {

  /**
   * Check if user is auth or not via API call
   */
  update: function update(orderId, params, callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/customer/orders/" + orderId,
      data: { order: params }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }
};

module.exports = Order;

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

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  setPackageSetQuantity: function setPackageSetQuantity(packageSetId, quantity, callback) {

    $.ajax({
      method: "PATCH",
      url: "/api/guest/package_sets/" + packageSetId,
      data: { "quantity": quantity }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  addSku: function addSku(productId, skuId, quantity, callback) {
    $.ajax({
      method: "POST",
      url: "/api/guest/order_items",
      data: { product_id: productId, sku_id: skuId, quantity: quantity }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  removeProduct: function removeProduct(orderItemId, callback) {
    $.ajax({
      method: "DELETE",
      url: "/api/guest/order_items/" + orderItemId

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  removeOrder: function removeOrder(orderId, callback) {
    $.ajax({
      method: "DELETE",
      url: "/api/customer/orders/" + orderId

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  addPackageSet: function addPackageSet(packageSetId, callback) {
    $.ajax({
      method: "POST",
      url: "/api/guest/package_sets?",
      data: { "package_set_id": packageSetId }

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = OrderItem;

});

require.register("javascripts/models/order_payment.js", function(exports, require, module) {
"use strict";

/**
 * OrderPayment Class
 */
var OrderPayment = {

  /**
   * Get the ProductSku details
   */
  show: function show(orderPaymentId, callback) {

    $.ajax({

      method: "GET",
      url: '/api/customer/order_payments/' + orderPaymentId,
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = OrderPayment;

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

      if (typeof err == "undefined") {
        return;
      }

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

      if (typeof err == "undefined") {
        return;
      }

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

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  },

  /**
   * Get all the Skus from the Product
   */
  all: function all(productId, callback) {

    $.ajax({

      method: "GET",
      url: '/api/guest/products/' + productId + '/skus',
      data: {}

    }).done(function (res) {

      callback(res);
    }).error(function (err) {

      if (typeof err == "undefined") {
        return;
      }

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

      if (typeof err == "undefined") {
        return;
      }

      callback({ success: false, error: err.responseJSON.error });
    });
  }

};

module.exports = Translations;

});

require.register("javascripts/services/refresh_total_products.js", function(exports, require, module) {
'use strict';

/**
 * RefreshTotalProducts Class
 */
var RefreshTotalProducts = {

  /**
   * Refresh it
   */
  perform: function perform() {

    var Cart = require('javascripts/models/cart');
    Cart.total(function (res) {
      $(".js-total-products").html(res.datas);
      RefreshTotalProducts.resolveHiding(res.datas);
    });
  },

  resolveHiding: function resolveHiding(total) {
    if (total > 0) {
      $('.js-total-products').removeClass('+hidden');
    } else {
      $('.js-total-products').addClass('+hidden');
    }
  }

};

module.exports = RefreshTotalProducts;

});

require.register("javascripts/starters.js", function(exports, require, module) {
'use strict';

/**
 * Starters Class
 */
var Starters = ['anti_cache', 'auto_resize', 'back_to_top', 'bootstrap', 'charts', 'datepicker', 'editable_fields', 'footer', 'input_validation', 'images_handler', 'lazy_loader', 'left_menu', 'links_behaviour', 'messages', 'mobile_menu', 'mobile', 'navigation', 'product_favorite', 'product_form', 'products_list', 'qrcode', 'refresh_time', 'responsive', 'search', 'sku_form', 'sweet_alert', 'table_clicker', 'tooltipster', 'total_products', 'weixin'];

module.exports = Starters;

});

require.register("javascripts/starters/anti_cache.js", function(exports, require, module) {
'use strict';

var UrlProcess = require('javascripts/lib/url_process');

/**
 * AntiCache Class
 */
var AntiCache = {

  /**
   * Initializer
   */
  init: function init() {

    this.setupAntiCache();
  },


  /**
   * When the param cache=false then we refresh the page with a timer
   * It's a global system throughout all pages
   */
  setupAntiCache: function setupAntiCache() {
    // If the cache is off ; `cache=false` in parameters
    // And check if time is not written already as well
    if (this.cacheOff() && !this.timePresent()) {
      this.insertCurrentTime();
    }
  },


  // This will refresh the page and add time=SOMETIME in the URL
  insertCurrentTime: function insertCurrentTime() {
    UrlProcess.insertParam('time', jQuery.now());
  },
  cacheOff: function cacheOff() {
    return UrlProcess.urlParam('cache') == "false";
  },


  // Is the time parameter present ?
  timePresent: function timePresent() {
    return typeof UrlProcess.urlParam('time') != "undefined";
  }
};

module.exports = AntiCache;

});

require.register("javascripts/starters/auto_resize.js", function(exports, require, module) {
'use strict';

/**
 * AutoResize Class
 */
var AutoResize = {

  /**
   * Initializer
   */
  init: function init() {

    this.setupAutoResize();
  },

  setupAutoResize: function setupAutoResize() {

    $('textarea').textareaAutoSize();
  }
};

module.exports = AutoResize;

});

require.register("javascripts/starters/back_to_top.js", function(exports, require, module) {
'use strict';

/**
 * BackToTop Class
 */
var BackToTop = {

  /**
  * Initializer
  */
  init: function init() {

    this.setupBackToTop();
  },

  /**
   * Back to top button system
   * NOTE : This was taken from the Internet
   * Don't hesitate to refactor if needed
   */
  setupBackToTop: function setupBackToTop() {

    $(function () {
      $.scrollUp({
        scrollName: 'scrollUp', // Element ID
        scrollDistance: 300, // Distance from top/bottom before showing element (px)
        scrollFrom: 'top', // 'top' or 'bottom'
        scrollSpeed: 300, // Speed back to top (ms)
        easingType: 'linear', // Scroll to top easing (see http://easings.net/)
        animation: 'fade', // Fade, slide, none
        animationSpeed: 200, // Animation speed (ms)
        scrollTrigger: false, // Set a custom triggering element. Can be an HTML string or jQuery object
        scrollTarget: false, // Set a custom target element for scrolling to. Can be element or number
        scrollText: '<i class="fa fa-caret-up"></i>', // Text for element, can contain HTML
        scrollTitle: false, // Set a custom <a> title if required.
        scrollImg: false, // Set true to use image
        activeOverlay: false, // Set CSS color to display scrollUp active point, e.g '#00FFFF'
        zIndex: 2147483647 // Z-Index for the overlay
      });
    });
  }

};

module.exports = BackToTop;

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

require.register("javascripts/starters/charts.js", function(exports, require, module) {
'use strict';

var ChartModel = require("javascripts/models/chart");
/**
 * Charts Class
 */
var Charts = {

  /**
  * Initializer
  */
  init: function init() {

    this.setupCharts();
  },

  /**
   * This will try to render any chart present on the HTML
   * <canvas class="js-chart" data-action="total_users" width="500" height="150"></canvas>
   */
  setupCharts: function setupCharts() {
    // We will load one after the other each chart
    // with their matching action
    $('.js-chart').each(function (index, value) {
      var action = $(this).data('action');
      var metadata = $(this).data('metadata');
      Charts.renderChart(action, metadata, $(this));
    });
  },

  renderChart: function renderChart(action, metadata, target) {
    ChartModel.get(action, metadata, function (res) {
      Charts.pluginNumbers();
      new Chart(target, res.data);
    });
  },

  pluginNumbers: function pluginNumbers() {

    // Define a plugin to provide data labels
    Chart.plugins.register({
      afterDatasetsDraw: function afterDatasetsDraw(chart, easing) {
        // To only draw at the end of animation, check for easing === 1
        var ctx = chart.ctx;

        // Numbers option is on
        if (chart.data.numbers) {

          chart.data.datasets.forEach(function (dataset, i) {
            var meta = chart.getDatasetMeta(i);
            if (!meta.hidden) {
              meta.data.forEach(function (element, index) {
                // Draw the text in black, with the specified font
                ctx.fillStyle = dataset.backgroundColor;

                var fontSize = 14;
                var fontStyle = 'bold';
                var fontFamily = 'Helvetica Neue';
                ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

                // Just naively convert to string for now
                var dataString = dataset.data[index].toString();

                // Make sure alignment settings are correct
                ctx.textAlign = 'center';
                ctx.textBaseline = 'middle';

                var padding = 5;
                var position = element.tooltipPosition();
                ctx.fillText(dataString, position.x, position.y - fontSize / 2 - padding);
              });
            }
          });
        }
      }
    });
  }

};

module.exports = Charts;

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

      if ($('#datepicker').length > 0) {
        $("#datepicker").datepicker({
          changeMonth: true,
          changeYear: true,
          yearRange: '1945:' + new Date().getFullYear(),
          dateFormat: "yy-mm-dd"
        });
      }

      if ($('#future-datepicker').length > 0) {
        $("#future-datepicker").datepicker({
          changeMonth: true,
          changeYear: true,
          yearRange: new Date().getFullYear() + ':2020',
          dateFormat: "yy-mm-dd"
        });
      }
    }
  }

};

module.exports = Datepicker;

});

require.register("javascripts/starters/editable_fields.js", function(exports, require, module) {
'use strict';

/**
* EditableFields Class
* Will make the edit fields appear and the text disappear
* It's used in the order edit for admin (for example)
* This is a very small system, not ambitious at all
* Keep it this way or use a real plugin.
*/
var EditableFields = {

  /**
  * Initializer
  */
  init: function init() {

    this.hideAllEditable();
    $('.js-editable-click').on('click', $.proxy(this.manageShowEditable, this));
  },

  manageShowEditable: function manageShowEditable(e) {
    e.preventDefault();
    this.showEditable(e.currentTarget);
  },

  hideAllEditable: function hideAllEditable() {
    $('.js-editable-text').show();
    $('.js-editable-field').hide();
    $('.js-editable-click').show();
    $('.js-editable-submit').hide();
  },

  hideEditable: function hideEditable(element) {
    $(element).parent().find('.js-editable-text').show();
    $(element).parent().find('.js-editable-field').hide();
    $(element).parent().find('.js-editable-click').show();
    $(element).parent().find('.js-editable-submit').hide();
  },

  showEditable: function showEditable(element) {
    $(element).parent().find('.js-editable-text').hide();
    $(element).parent().find('.js-editable-field').show();
    $(element).parent().find('.js-editable-click').hide();
    $(element).parent().find('.js-editable-submit').show();
  }

};

module.exports = EditableFields;

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

    $('.js-footer-stick').css('margin-top', 0);

    var docHeight = $(window).height();
    var footerHeight = $('.js-footer-stick').height();
    var headerHeight = $('.navbar-fixed-top').first().height();
    var footerTop = $('.js-footer-stick').position().top + footerHeight;

    if (footerTop < docHeight) {
      $('.js-footer-stick').css('margin-top', docHeight + headerHeight * 1.30 - footerTop + 'px');
    }
  }

};

module.exports = Footer;

});

require.register("javascripts/starters/images_handler.js", function(exports, require, module) {
"use strict";

/**
* ImagesHandler Class
*/
var ImagesHandler = {

  elements: {
    image: ".js-file-upload"
  },

  /**
  * Initializer
  */
  init: function init() {

    this.validateImageFile();
    this.imageLiveRefresh();
  },

  /**
  * Validate the image itself when it's changed
  * @return {void}
  */
  validateImageFile: function validateImageFile() {

    $(ImagesHandler.elements.image).on('change', function () {

      var Messages = require("javascripts/lib/messages");
      var Translation = require("javascripts/lib/translation");
      var inputFile = this;

      var maxExceededMessage = Translation.find('max_exceeded_message', 'image_upload');
      var extErrorMessage = Translation.find('ext_error_message', 'image_upload');
      var allowedExtension = ["jpg", "JPG", "jpeg", "JPEG", "png", "PNG"];
      var extName;
      var maxFileSize = 1048576 * 3; // 3MB
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
  },

  /**
  * This system is basically live refreshing the images when you select one from your browser
  * It's mainly used by the shopkeepers
  * @return {void}
  */
  imageLiveRefresh: function imageLiveRefresh() {

    if ($(ImagesHandler.elements.image).length > 0) {

      $(ImagesHandler.elements.image).each(function () {

        var fileElement = $(this);

        $(this).change(function (event) {
          var input = $(event.currentTarget);
          var file = input[0].files[0];
          var reader = new FileReader();
          reader.onload = function (e) {
            var image_base64 = e.target.result;

            var image_div = fileElement.attr('image_selector');
            $(image_div).attr("src", image_base64);

            // we show the update
            var add_link = fileElement.attr('image_selector') + '_add';
            $(add_link).removeClass('hidden');
          };
          reader.readAsDataURL(file);
        });
      });
    }
  }

};

module.exports = ImagesHandler;

});

require.register("javascripts/starters/input_validation.js", function(exports, require, module) {
'use strict';

/**
* InputValidation Class
*/
var InputValidation = {

  /**
  * Initializer
  */
  init: function init() {

    this.restrictToChinese();
  },

  /**
   * USE : just add data-error to an input to have the custom error show up
   */
  restrictToChinese: function restrictToChinese() {

    $("input").on('invalid', function (e) {
      if (typeof $(this).data('error') != "undefined") {
        this.setCustomValidity($(this).data('error'));
      }
    });

    $("input").on('keyup', function (e) {
      this.setCustomValidity("");
    });
  }

};

module.exports = InputValidation;

});

require.register("javascripts/starters/lazy_loader.js", function(exports, require, module) {
"use strict";

/**
 * LazyLoader Class
 */
var LazyLoader = {

  /**
   * Initializer
   */
  init: function init() {

    this.startLazyLoader();
  },

  /**
   *
   */
  startLazyLoader: function startLazyLoader() {

    $("div.lazy").lazyload({
      effect: "fadeIn",
      threshold: 650
    });
  }

};

module.exports = LazyLoader;

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

    $('select.nice').niceSelect();
    $('.overlay').on('click', function (e) {
      $('#mobile-menu-button').trigger('click');
    });

    // NOTE : no idea what this is, i think it doesn't exist anymore
    // - Laurent 26/01/2017
    // $('#left_menu > ul > li > a').click(function() {
    //     $('#left_menu li').removeClass('active');
    //     $(this).closest('li').addClass('active');
    //     var checkElement = $(this).next();
    //     if((checkElement.is('ul')) && (checkElement.is(':visible'))) {
    //         $(this).closest('li').removeClass('active');
    //         checkElement.slideUp('normal');
    //     }
    //     if((checkElement.is('ul')) && (!checkElement.is(':visible'))) {
    //         $('#left_menu ul ul:visible').slideUp('normal');
    //         checkElement.slideDown('normal');
    //     }
    //     if($(this).closest('li').find('ul').children().length == 0) {
    //         return true;
    //     } else {
    //         return false;
    //     }
    // });
  }

};

module.exports = LeftMenu;

});

require.register("javascripts/starters/links_behaviour.js", function(exports, require, module) {
'use strict';

/**
 * LinkBehaviour Class
 */
var LinkBehaviour = {

  /**
   * Initializer
   */
  init: function init() {

    this.setupSubmitForm();
  },

  /**
   * If we use the data-submit-form it will force submit with a simple link
   */
  setupSubmitForm: function setupSubmitForm() {

    $(document).on('click', '[data-form="submit"]', function (e) {
      e.preventDefault();
      $(this).closest('form').submit();
    });
  }

};

module.exports = LinkBehaviour;

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

    if ($("#message-container-error").length > 0) {
      Messages.activateHide('#message-container-error', 4000);
      Messages.forceHide('#message-container-error');
    }

    if ($("#message-container-success").length > 0) {
      Messages.activateHide('#message-container-success', 5000);
      Messages.forceHide('#message-container-success');
    }
  }

};

module.exports = Messages;

});

require.register("javascripts/starters/mobile.js", function(exports, require, module) {
"use strict";

/**
 * AutoResize Class
 */
var AutoResize = {

  /**
   * Initializer
   */
  init: function init() {

    this.setupInternational();
  },

  setupInternational: function setupInternational() {

    $("#user_mobile").intlTelInput({
      nationalMode: false,
      preferredCountries: ["DE", "CN"],
      initialCountry: "DE"
    });

    $("#inquiry_mobile").intlTelInput({
      nationalMode: false,
      preferredCountries: ["DE", "CN"],
      initialCountry: "CN"
    });

    $("#address_mobile").intlTelInput({
      nationalMode: false,
      preferredCountries: ["DE", "CN"],
      initialCountry: "CN"
    });

    $("#shop_application_mobile").intlTelInput({
      nationalMode: false,
      preferredCountries: ["DE", "CN"],
      initialCountry: "DE"
    });

    $("#shop_application_tel").intlTelInput({
      nationalMode: false,
      preferredCountries: ["DE", "CN"],
      initialCountry: "DE"
    });
  }
};

module.exports = AutoResize;

});

require.register("javascripts/starters/mobile_menu.js", function(exports, require, module) {
'use strict';

/**
 * MobileMenu Class
 */
var MobileMenu = {

    /**
     * Initializer
     */
    init: function init() {

        this.startMobileMenu();
    },

    /**
     *
     */
    startMobileMenu: function startMobileMenu() {

        this.manageFade();
    },

    manageFade: function manageFade() {

        $('.navmenu').on('show.bs.offcanvas', function () {
            $('.canvas').addClass('sliding');
        }).on('shown.bs.offcanvas', function () {}).on('hide.bs.offcanvas', function () {
            $('.canvas').removeClass('sliding');
        }).on('hidden.bs.offcanvas', function () {});
    }

};

module.exports = MobileMenu;

});

require.register("javascripts/starters/navigation.js", function(exports, require, module) {
"use strict";

/**
 * Navigation Class
 */
var Navigation = {

  /**
   * Initializer
   */
  init: function init() {

    if ($('#js-navigation-disabled').length == 0) {

      this.storeNavigation();
    }
  },

  /**
   * We send the navigation to the back-end
   */
  storeNavigation: function storeNavigation() {

    var NavigationModel = require("javascripts/models/navigation_model");
    NavigationModel.setLocation(window.location.href, function (res) {
      // Nothing yet
    });
  }

};

module.exports = Navigation;

});

require.register("javascripts/starters/product_favorite.js", function(exports, require, module) {
"use strict";

var Translation = require('javascripts/lib/translation');
var Product = require("javascripts/models/product");
var Messages = require("javascripts/lib/messages");

/**
 * ProductFavorite Class
 */
var ProductFavorite = {

  /**
   * Initializer
   */
  init: function init() {

    this.setupHeartClick();
  },

  /**
   * manage the heart click events
   * @return {void}
   */
  setupHeartClick: function setupHeartClick() {
    this.heartElement().on('click', $.proxy(this.onHeartClick, this));
  },

  /**
   * Main button for the favorite system
   * @return {element}
   */
  heartElement: function heartElement() {
    return $('.js-heart-click');
  },

  /**
   * returns the productId of the product on the page@
   * @return {element}
   */
  productId: function productId() {
    return this.heartElement().attr('data-product-id');
  },

  /**
   * Is the product in favorite or not ?
   * @return {boolean}
   */
  isFavorite: function isFavorite() {
    return this.heartElement().attr('data-favorite') == '1';
  },

  /**
   * When the heart is clicked
   */
  onHeartClick: function onHeartClick(e) {

    e.preventDefault();

    if (this.isFavorite()) {
      this.removeFavorite();
    } else {
      this.addFavorite();
    }
  },

  /**
   * We unlike from the model and display the unlike
   * @return {void}
   */
  removeFavorite: function removeFavorite() {

    this.displayUnlike();
    this.modelUnlike($.proxy(this.updateTotalFavorites, this));
  },

  /**
   * We like from the model and display the like (heart)
   * @return {void}
   */
  addFavorite: function addFavorite() {

    this.displayLike();
    this.modelLike($.proxy(this.updateTotalFavorites, this));
  },

  /**
   * Update the favorites count on the display
   * @param  {Function} res
   * @return {void}
   */
  updateTotalFavorites: function updateTotalFavorites(res) {
    var favoritesCount = res.favorites.length;
    $('#total-likes').html(favoritesCount);
  },

  /**
   * Like the model and manage errors on the display
   * @param  {Function} callback
   * @return {Function}
   */
  modelLike: function modelLike(callback) {
    Product.like(this.productId(), this.handleModelResponse(callback));
  },

  /**
   * Unlike the model and manage errors on the display
   * @param  {Function} callback
   * @return {Function}
   */
  modelUnlike: function modelUnlike(callback) {
    Product.unlike(this.productId(), this.handleModelResponse(callback));
  },

  /**
   * Handle the model response if he likes or unlike
   * @param  {Function} callback
   * @return {Function}
   */
  handleModelResponse: function handleModelResponse(callback) {
    return function (response) {

      if (res.success === false) {
        Messages.makeError(res.error);
      } else {
        callback(response);
      }
    };
  },

  /**
   * Change the elements so they look unliked
   * @return {void}
   */
  displayUnlike: function displayUnlike() {
    this.heartElement().find('i').addClass('+grey').removeClass('+pink');
    this.heartElement().attr('data-favorite', '0');
    this.heartElement().find('span').html(Translation.find('add', 'favorites'));
  },

  /**
   * Change the elements so they look liked
   * @return {void}
   */
  displayLike: function displayLike(el) {
    this.heartElement().find('i').addClass('+pink').removeClass('+grey');
    this.heartElement().attr('data-favorite', '1');
    this.heartElement().find('span').html(Translation.find('remove', 'favorites'));
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

      // TODO : it doesn't seems it's used in the system anymore
      // $('#edit_product_submit_btn').click( function() {
      //
      //       $('input.dynamical-required').each(
      //         function () {
      //           if ( $(this).val().length == 0 ) {
      //             console.log('yes');
      //             $(this).addClass('invalidBorderClass');
      //           } else {
      //             $(this).removeClass('invalidBorderClass');
      //           }
      //         }
      //       );
      //
      //       if ( $('.invalidBorderClass').length > 0 ) {
      //         return false;
      //       }
      //
      //     });
      //
      //     $('a[rel=popover]').popover();
      //
      //     var panel_cnt = $("#variants_panel_"+productId).children('.panel-body').find('.panel').length
      //     if (panel_cnt == 0) $("#a_add_variant_"+productId).click();
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

  manageProductsWall: function manageProductsWall() {}

};

module.exports = ProductsList;

});

require.register("javascripts/starters/qrcode.js", function(exports, require, module) {
'use strict';

/**
 * QrCode Class
 */
var QrCode = {

  initialized: false,

  /**
   * Initializer
   */
  init: function init() {

    $(window).on('resize', _.debounce($.proxy(this.onResize, this), 300)).trigger('resize');
  },

  onResize: function onResize(e) {

    if (this.isMobile() && this.initialized) {
      this.destroy();
      return;
    }

    if (this.isMobile()) {
      return;
    }

    if (!this.initialized) {
      this.setupWechat();
      this.setupWeibo();
      this.initialized = true;
      return;
    }
  },

  isMobile: function isMobile() {
    /**
     * NOTE : this 994 matches with the breakpoint of `=breakpoint` in SASS
     * Please be careful and change the one in the SASS as well
     */
    return $(window).width() <= 994;
  },

  destroy: function destroy() {
    $('#weibo-qr-code-trigger').off('mouseover').off('mouseout');
    $('#wechat-qr-code-trigger').off('mouseover').off('mouseout');
    $('#wechat-qr-code').addClass('hidden');
    $('#weibo-qr-code').addClass('hidden');
    QrCode.initialized = false;
  },

  setupWechat: function setupWechat() {

    $('#wechat-qr-code-trigger').on('mouseover', function (e) {
      $('#wechat-qr-code').removeClass('hidden');
    });

    $('#wechat-qr-code-trigger').on('mouseout', function (e) {
      $('#wechat-qr-code').addClass('hidden');
    });

    $('#wechat-qr-code-trigger').on('click', function (e) {
      if ($('#wechat-qr-code').hasClass('hidden')) {
        $('#wechat-qr-code').removeClass('hidden');
      } else {
        $('#wechat-qr-code').addClass('hidden');
      }
    });
  },

  setupWeibo: function setupWeibo() {

    $('#weibo-qr-code-trigger').on('mouseover', function (e) {
      $('#weibo-qr-code').removeClass('hidden');
    });

    $('#weibo-qr-code-trigger').on('mouseout', function (e) {
      $('#weibo-qr-code').addClass('hidden');
    });

    $('#weibo-qr-code-trigger').on('click', function (e) {
      if ($('#weibo-qr-code').hasClass('hidden')) {
        $('#weibo-qr-code').removeClass('hidden');
      } else {
        $('#weibo-qr-code').addClass('hidden');
      }
    });
  }

};

module.exports = QrCode;

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
'use strict';

/**
 * Responsive Class
 */
var Responsive = {

  /**
   * Initializer
   */
  init: function init() {

    this.manageCategoriesMenu();
  },

  manageCategoriesMenu: function manageCategoriesMenu() {

    if ($('.mobile-category-menu').length > 0) {

      var Translation = require('javascripts/lib/translation');

      $('#categories-menu').slicknav({

        "prependTo": ".mobile-category-menu", //".container-fluid"
        "label": Translation.find('menu', 'button'),
        "closeOnClick": true

      });

      // We hook the slicknav menu with some HTML content
      // It will occur after the menu is ready.
      // To stay clean it takes an invisible element within the HTML
      var left_side_content = $('#categories-menu-left-side').html();
      $('.slicknav_menu').prepend(left_side_content);
    }
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

    this.categoryFilter();
    this.brandFilter();
    this.searchInput();
    this.statusFilter();
  },

  /**
   * We make the search behavior
   */
  searchInput: function searchInput() {

    $('.js-search-button i').on('click', function (e) {
      e.preventDefault(); // prevent go back to the header
      Search.showSearchForm();
      $('.js-search-input').focus();
    });

    $('.js-search-input').on('focusout', function (e) {
      Search.hideSearchForm();
    });
  },

  showSearchForm: function showSearchForm() {
    $('.js-search-button').addClass('+hidden');
    $('.js-search-form').removeClass('+hidden');
  },

  hideSearchForm: function hideSearchForm() {
    $('.js-search-button').removeClass('+hidden');
    $('.js-search-form').addClass('+hidden');
  },

  /**
   * We make the brand filter auto-trigger
   */
  brandFilter: function brandFilter() {

    $('select.js-package-set-brand-filter').on('change', function (e) {

      var brand_id = $(this).val(); // current selected value
      var option = $(this).find("option:selected"); // let's get inside the option itself
      var href = option.data("href"); // get the href if it exists

      if (typeof href !== "undefined") {

        window.location.href = location.protocol + '//' + location.host + href;
        // document.location = location.host + href;
      } else {
        // we will refresh the current page the category id
        var UrlProcess = require('javascripts/lib/url_process');
        UrlProcess.insertParam('brand_id', brand_id);
      }
    });
  },

  /**
   * We make the category filter auto-trigger
   */
  categoryFilter: function categoryFilter() {

    $('select.js-package-set-category-filter').on('change', function (e) {

      var category_id = $(this).val(); // current selected value
      var option = $(this).find("option:selected"); // let's get inside the option itself
      var href = option.data("href"); // get the href if it exists

      if (typeof href !== "undefined") {

        window.location.href = location.protocol + '//' + location.host + href;
        // document.location = location.host + href;
      } else {
        // we will refresh the current page the category id
        var UrlProcess = require('javascripts/lib/url_process');
        UrlProcess.insertParam('category_id', category_id);
      }
    });
  },

  statusFilter: function statusFilter() {
    $('.js-order-status-filter').on('change', function (e) {

      var status = $(this).val();

      var UrlProcess = require('javascripts/lib/url_process');
      UrlProcess.insertParam('status', status);
    });
  }

};

module.exports = Search;

});

require.register("javascripts/starters/sku_form.js", function(exports, require, module) {
'use strict';

/**
 * SkuForm Class
 * TODO : this classe should be moved over to the sku area only
 * it's not a starter or anything like that, spreading prop changes
 * on the global system is not safe.
 */
var SkuForm = {

  elements: {
    form: '#sku_form',
    checkbox: '#sku_unlimited',
    input: '#sku_quantity'
  },

  /**
   * Initializer
   */
  init: function init() {

    this.setupLimitSystem();
  },

  /**
   * If we are on the correct page containing `js-sku-form`
   * We setup the limit display and activate the checkbox click listener
   * @return {void}
   */
  setupLimitSystem: function setupLimitSystem() {

    if ($("#js-sku-form").length == 0) {
      return;
    }

    SkuForm.resetLimitDisplay();

    $(SkuForm.elements.checkbox).on('click', function () {
      SkuForm.resetLimitDisplay();
    });
  },

  /**
   * Reset the limit display
   * It will show or hide the input
   * @return {void}
   */
  resetLimitDisplay: function resetLimitDisplay() {
    if ($(SkuForm.elements.checkbox).is(":checked")) {
      SkuForm.switchOffLimit();
      return;
    }
    SkuForm.switchOnLimit();
  },

  /**
   * We disable the limit input and make it unlimited
   * @return {void}
   */
  switchOffLimit: function switchOffLimit() {
    $(SkuForm.elements.form).find(SkuForm.elements.input).val('0').prop('disabled', 'true').parent().hide();
  },

  /**
   * We activate the limit input and make it limited
   * @return {void}
   */
  switchOnLimit: function switchOnLimit() {
    $(SkuForm.elements.form).find(SkuForm.elements.input).removeAttr('disabled').parent().show();
  }

};

module.exports = SkuForm;

});

require.register("javascripts/starters/sweet_alert.js", function(exports, require, module) {
"use strict";

/**
 * SweetAlert Class
 */
var SweetAlert = {

  /**
   * Initializer
   */
  init: function init() {

    this.startAlert();
  },

  /**
   *
   */
  startAlert: function startAlert() {
    /*
          $.rails.allowAction = function(link){
      if (link.data("confirm") == undefined){
        console.log("fuck it");
        return true;
      }
      $.rails.showConfirmationDialog(link);
      return false;
    */
    //}

    /* NOT COMPATIBLE WITH RAILS SYSTEM ...
          $('.js-alert').click(function(e) {
    
            e.preventDefault();
            self = this;
    
            swal({
              title: $(self).data('title') || "Are you sure ?",
              text: $(self).data('text') || "This action cannot be undone.",
              type: "warning",
              showCancelButton: true,
              confirmButtonColor: "#DD6B55",
              confirmButtonText: "Yes, delete it!",
              closeOnConfirm: false
            }, function(){
              swal({
                title: "Processing!",
                text: "Your request is being processed ...",
                type: 'success',
                showConfirmButton: false
              });
              window.location.href = $(self).attr('href');
            });
    
          })
    */
  }

};

module.exports = SweetAlert;

});

require.register("javascripts/starters/table_clicker.js", function(exports, require, module) {
'use strict';

/**
 * TableClicker Class
 */
var TableClicker = {

  /**
   * Initializer
   */
  init: function init() {

    this.handleTableClicker();
  },

  handleTableClicker: function handleTableClicker() {
    $('tr').on('click', TableClicker.onClickTr);
  },

  onClickTr: function onClickTr(e) {
    var link = $(e.currentTarget).data('href');
    if (typeof link !== "undefined") {
      window.location = link;
    }
  }

};

module.exports = TableClicker;

});

require.register("javascripts/starters/tooltipster.js", function(exports, require, module) {
'use strict';

/**
 * Tooltipster Class
 */
var Tooltipster = {

  /**
   * Initializer
   */
  init: function init() {

    this.activateTooltipster();
  },

  activateTooltipster: function activateTooltipster() {

    $('.tooltipster-click').tooltipster({
      animation: 'fade',
      delay: 200,
      trigger: 'click',
      maxWidth: 350,
      timer: 1000
    });

    $('.tooltipster').tooltipster({
      'maxWidth': 350
    });
  }

};

module.exports = Tooltipster;

});

require.register("javascripts/starters/total_products.js", function(exports, require, module) {
'use strict';

/**
 * TotalProducts Class
 */
var TotalProducts = {

  /**
   * Initializer
   */
  init: function init() {

    this.refreshTotalProducts();
  },

  refreshTotalProducts: function refreshTotalProducts() {

    var refreshTotalProducts = require('../services/refresh_total_products');
    refreshTotalProducts.resolveHiding($('.js-total-products').html());
    //refreshTotalProducts.perform();
    // <-- NOTE : this will make a condition race
    // we found no solution but to just show manually and render from server side to avoid it.
  }
};

module.exports = TotalProducts;

});

require.register("javascripts/starters/weixin.js", function(exports, require, module) {
'use strict';

var _vueClipboard = require('vue-clipboard2');

var _vueClipboard2 = _interopRequireDefault(_vueClipboard);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/**
 * WeixinStarter Class
 * BIG NOTE : this system is the first we use with VueJS
 * it needs a lot of refactoring as it mixes up the Weixin system, with a clipboard system, with a Sharing system
 * which should be split into differente files.
 */
var WeixinStarter = {

  weixinVue: null,
  setupWeixinVue: function setupWeixinVue() {

    this.vueTooltipDirective();

    Vue.use(_vueClipboard2.default);

    this.weixinVue = new Vue({
      el: '#weixin-vue',
      data: {
        shared: false,
        loaded: false,
        copied: null
      },
      watch: {
        shared: function shared(_shared) {
          if (_shared === true) {
            window.location.href = WeixinStarter.shareLinkData().back;
          }
        },
        loaded: function loaded(_loaded) {
          if (_loaded === true) {}
        }
      },
      methods: {
        copySuccess: function copySuccess() {
          this.copied = true;
        },
        copyFail: function copyFail() {
          this.copied = false;
        }
      }
    });
  },

  vueTooltipDirective: function vueTooltipDirective() {
    Vue.directive('tooltip', {
      bind: function bind(el) {
        WeixinStarter.clickTooltip(el);
      }
    });
  },

  clickTooltip: function clickTooltip(el) {
    $(el).on('click', function (e) {
      e.preventDefault();
    });
    $(el).tooltipster({
      animation: 'fade',
      delay: 200,
      trigger: 'click',
      maxWidth: 350,
      timer: 1000
    });
  },

  /**
   * Initializer
   */
  init: function init() {

    if ($('#weixin-vue').length > 0) {
      this.setupWeixinVue();
    }

    if (typeof this.data() !== "undefined") {
      this.config();
      this.onReady();
      this.onError();
    }
  },

  data: function data() {
    return $('#weixin').data();
  },

  shareLinkData: function shareLinkData() {
    return $('#weixin-share-link').data();
  },

  config: function config() {
    wx.config({
      debug: this.data().debug,
      appId: this.data().appId,
      timestamp: this.data().timestamp,
      nonceStr: this.data().nonceStr,
      signature: this.data().signature,
      jsApiList: this.data().jsApiList
    });
  },

  onReady: function onReady() {
    wx.ready(function () {
      WeixinStarter.weixinVue.loaded = true;
      // WeixinStarter.checkJsApi();
      WeixinStarter.onMenuShareTimeline();
      WeixinStarter.onMenuShareAppMessage();
    });
  },

  onError: function onError() {
    wx.error(function (res) {
      console.log('Weixin received an error : ' + res.errMsg);
    });
  },

  checkJsApi: function checkJsApi() {
    wx.checkJsApi({
      jsApiList: this.data().jsApiList,
      success: function success(res) {
        console.log('Check Api : ' + res.checkResult);
      }
    });
  },

  onMenuShareTimeline: function onMenuShareTimeline() {
    if (this.shareLinkAvailable()) {
      wx.onMenuShareTimeline(WeixinStarter.shareLinkParams());
    }
  },

  onMenuShareAppMessage: function onMenuShareAppMessage() {
    if (this.shareLinkAvailable()) {
      wx.onMenuShareAppMessage(WeixinStarter.shareLinkParams());
    }
  },

  shareLinkAvailable: function shareLinkAvailable() {
    return typeof this.shareLinkData() !== "undefined";
  },

  shareLinkParams: function shareLinkParams() {
    return {
      desc: WeixinStarter.shareLinkData().desc,
      imgUrl: WeixinStarter.shareLinkData().imgUrl,
      link: WeixinStarter.shareLinkData().link,
      title: WeixinStarter.shareLinkData().title,

      success: function success() {
        WeixinStarter.weixinVue.shared = true;
      },
      cancel: function cancel() {}
    };
  }

};

module.exports = WeixinStarter;

});

require.register("___globals___", function(exports, require, module) {
  
});})();require('___globals___');


//# sourceMappingURL=app.js.map