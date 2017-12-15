import VueAwesomeSwiper from 'vue-awesome-swiper'

/**
* PackageSetsShow Class
* We use vue for a carousel system within the page
*/
var PackageSetsShow = {

  vue: null,
  init: function() {

    // everything is auto managed ... incredible vuejs.
    Vue.use(VueAwesomeSwiper);

    this.vue = new Vue({
      el: '#slider-vue',
      data: {
      },
      watch: {
      },
      methods: {
      },
    });
  },
}

module.exports = PackageSetsShow;
