import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#companies_index',
    data: {
      modal2: {}
    },
    methods: {
      modalId(i){
        Vue.set(this.modal2, i , !this.modal2[i]);
      }
    }
  })
})
