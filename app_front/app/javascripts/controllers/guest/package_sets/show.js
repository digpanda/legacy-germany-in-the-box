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
            let packageSetId = $(this).data('package-set-id');
            console.log(packageSetId);

            OrderItem.addPackageSet(packageSetId, function(res) {

                var Messages = require("javascripts/lib/messages");

                if (res.success === true) {

                    Messages.makeSuccess(res.message);

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
