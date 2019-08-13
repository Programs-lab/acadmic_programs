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
  if(document.getElementById('schedule_appointments')) {
    var app = new Vue({
      el: '#schedule_appointments',
      data: {
        modal2: {}
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        visitLocation(path){
          if (event.target.id != "cancelBtn") Turbolinks.visit(path)
        }
      }
    })
  }
})
