import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#flash',
    data: {
      alert: false
    },
    methods: {
      close() {
          this.alert =! this.alert;
          document.getElementById('flash2').parentNode.removeChild(document.getElementById('flash2'));
      }
    }
  })
})
