import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
import Datepicker from 'vuejs-datepicker';
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('procedures_index')) {
    var element = document.getElementById('procedures_index')
    var app = new Vue({
      el: '#procedures_index',
      data: {
        modal2: {},
        procedureDateValue: ""
      },
      components: {
        Datepicker
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        }
      }
    })
  }
})
