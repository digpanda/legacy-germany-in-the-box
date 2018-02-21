import VueAwesomeSwiper from 'vue-awesome-swiper'
// require styles
// import 'swiper/dist/css/swiper.css'

/**
* Sliders Class
* We use vue for a carousel system within the page
*/
var Sliders = {

  vue: null,
  init: function() {

    // everything is auto managed ... incredible vuejs.
    Vue.use(VueAwesomeSwiper);
    Sliders.setupSlider();
    console.log('slider')
  },

  setupSlider: function() {
    if ($('#slider-vue').length > 0) {
      if ($('#js-device').data('current') == 'mobile') {
        Sliders.vue = Sliders.mobileSlider();
      } else {
        Sliders.vue = Sliders.desktopSlider();
      }
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

module.exports = Sliders;
