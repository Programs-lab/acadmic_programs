import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#nav_bar',
    data: {
      show: false
    },
    methods: {
      close() {
          this.show = false
      }
    }
  })
})
