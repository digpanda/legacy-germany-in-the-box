var Translation = require("javascripts/lib/translation");
/**
 * PackageSeyShow Class
 */
var PackageSetsShow = {

    /**
     * Initializer
     */
    init: function() {

        this.manageAddPackageSet();

    },

    manageAddPackageSet: function () {

        $('#add-package-set').on('click', function (e) {

            e.preventDefault();

            var OrderItem = require("javascripts/models/order_item");
            let url = $(this).data('url');
            console.log(url);

            OrderItem.addPackageSet(url, function(res) {

                var Messages = require("javascripts/lib/messages");

                if (res.success === true) {

                    Messages.makeSuccess(res.msg);

                    var refreshTotalProducts = require('javascripts/services/refresh_total_products');
                    refreshTotalProducts.perform();

                } else {

                    Messages.makeError(res.error)

                }
            });

        })

    }
};

module.exports = PackageSetsShow;
