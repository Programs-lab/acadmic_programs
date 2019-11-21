import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('faculties_form')) {
    var app = new Vue({
      el: '#faculties_form',
      data: {
        modal2: {}
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        }
      }
    })
  }
})
