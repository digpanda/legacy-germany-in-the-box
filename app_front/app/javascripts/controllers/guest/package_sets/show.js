import VueAwesomeSwiper from 'vue-awesome-swiper'
// require styles
// import 'swiper/dist/css/swiper.css'

/**
* Show Class
* We use vue for a carousel system within the page
*/
var Show = {

  vue: null,
  init: function() {

    // everything is auto managed ... incredible vuejs.
    console.log('loading')
    Vue.use(VueAwesomeSwiper);
    Show.setupSlider();
  },

  setupSlider: function() {
    if ($('#js-device').data('current') == 'mobile') {
      Show.vue = Show.mobileSlider();
    } else {
      Show.vue = Show.desktopSlider();
    }
  },

  mobileSlider: function() {
    return new Vue({
      el: '#slider-vue',
      data: {
        swiperOption: {
          slidesPerView: 1,
          spaceBetween: 20,
          pagination: {
            el: '.swiper-pagination',
            clickable: true
          }
        }
      }
    });
  },

  desktopSlider: function() {
    return new Vue({
      el: '#slider-vue',
      data: {
        swiperOption: {
          slidesPerView: 3,
          spaceBetween: 20,
          pagination: {
            el: '.swiper-pagination',
            clickable: true
          }
        }
      }
    });
  },

}

module.exports = Show;
