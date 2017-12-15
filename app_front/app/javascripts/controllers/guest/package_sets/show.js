import VueAwesomeSwiper from 'vue-awesome-swiper'
// require styles
// import 'swiper/dist/css/swiper.css'

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
        swiperOption: {
          slidesPerView: 3,
          spaceBetween: 30,
          pagination: {
            el: '.swiper-pagination',
            clickable: true
          }
        }
      }
    });
  },
}

module.exports = PackageSetsShow;
