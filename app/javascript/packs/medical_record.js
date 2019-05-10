import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import VueMoment from 'vue-moment';
import moment from 'moment';
Vue.use(TurbolinksAdapter)
Vue.use(VueMoment, { moment } );
moment.locale('es')

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('medical_record')) {
    var appointment = JSON.parse(document.getElementById("medical_record_form").getAttribute('appointment'))
    if (JSON.stringify(appointment) == "{}") {
      appointment['id'] = ""
      appointment['appointment_datetime'] = moment().format()
    }
    var app = new Vue({
      el: '#medical_record',
      data: {
        show: false,
        showM: false,
        showC: false,
        algo: false,
        tabItems: {},
        modal2: {},
        appointment: appointment
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        showText(){
          this.show =! this.show
        },
        showMedicalRecord(){
          this.showM =! this.showM
        }
      },
      computed: {
        classIconButton: function(){
          return {
            'fa-plus btn-primary': !this.show,
            'fa-trash btn-red-light': this.show
          }
        },
        transformClass: function(){
          return{
            'transform_collapse_2': !this.showC,
            'transform_collapse': this.showC,
          }
        },
        animatedClass: function(){
          return{
            'animated slideOutUp': !this.showC,
            'animated slideInDown': this.showC,
          }
        }
      }
    })
  }
})
