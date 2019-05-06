import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('flash')) {
    var app = new Vue({
      el: '#flash',
      data: {
        alert: false
      },
      methods: {
        close() {
            setTimeout(
              ()  => document.getElementById('flash2').parentNode.removeChild(document.getElementById('flash2')), 500);
            return this.alert =! this.alert;
        }
      },
      computed: {
        animatedFlash: function () {
          return {
            'animated fadeOut': this.alert,
            '': !this.alert,
          }
        }
      }
    })
  }
})
