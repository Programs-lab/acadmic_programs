import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import VueMoment from 'vue-moment';
import moment from 'moment';
import Ripple from 'vue-ripple-directive'
Vue.directive('ripple', Ripple);
Vue.use(TurbolinksAdapter)
Vue.use(VueMoment, { moment } );
moment.locale('es')

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('appointments_index')) {
    var app = new Vue({
      el: '#appointments_index',
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
