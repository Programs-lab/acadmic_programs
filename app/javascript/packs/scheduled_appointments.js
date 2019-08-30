import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import Datepicker from 'vuejs-datepicker';
import VueMoment from 'vue-moment';
import moment from 'moment';
import Ripple from 'vue-ripple-directive'
import {en, es} from 'vuejs-datepicker/dist/locale'
import Multiselect from 'vue-multiselect'
Vue.directive('ripple', Ripple);
Vue.use(TurbolinksAdapter)
Vue.use(VueMoment, { moment } );
moment.locale('es')

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('schedule_appointments')) {
    var highlighted_appointments = JSON.parse(document.getElementById("schedule_appointments").dataset.appointments)
    var array_of_dates = []
    highlighted_appointments.forEach(function(appointment) {array_of_dates.push(new Date(appointment.appointment_datetime))})
    var state = {
     highlighted: {
        dates: array_of_dates
     }
    }
    let docs = JSON.parse(document.getElementById("schedule_appointments").dataset.doctors)
    let pats = JSON.parse(document.getElementById("schedule_appointments").dataset.patients)
    let d_id = document.getElementById("schedule_appointments").dataset.doctor
    let p_id = document.getElementById("schedule_appointments").dataset.patient
    var app = new Vue({
      el: '#schedule_appointments',
      data: {
        modal2: {},
        date: document.getElementById("schedule_appointments").dataset.date,
        appointment_datetime: document.getElementById("schedule_appointments").dataset.appdate,
        es: es,
        highlighted_dates: state,
        doctors: docs,
        patients: pats,
        doctor: docs.filter(obj => {return obj.id == d_id})[0],
        patient: pats.filter(obj => {return obj.id == p_id})[0],
        doctor_id: d_id,
        patient_id: p_id
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        capitalizeFirstLetter(string) {
            return string.charAt(0).toUpperCase() + string.slice(1);
        },
        fullName({first_name, last_name}){
          return `${this.capitalizeFirstLetter(first_name.toLowerCase())} ${this.capitalizeFirstLetter(last_name.toLowerCase())}`
        },
        reload(){
          if (this.date !== null) {
            Turbolinks.visit(location.origin + location.pathname + `?date=${this.date}`)
          }
        },
        assingDoctorId(doc){
          if (doc === null) {
           this.doctor_id = '' 
          }
          else{
           this.doctor_id = this.doctor.id   
          }
        },
        assingPatientId(pat){
          if (pat === null) {
           this.patient_id = '' 
          }
          else{
           this.patient_id = this.patient.id   
          }
        }             
      },

      mounted: function(){
        var no_border = document.getElementById("no-border");
        if (no_border !== null) {
          no_border.parentNode.style.cssText = "border-bottom: 0px;"
        }
        for (var i = 0; i < 3; i++) {
          var multiple_select = document.getElementsByClassName('multiselect__tags')[0]
          if (typeof multiple_select !== 'undefined') {
            multiple_select.classList.remove("multiselect__tags")
            multiple_select.classList.add("field_input")
            multiple_select.classList.add("rounded-t")
          }
        }
      },

      components: {
        Datepicker,
        Multiselect
      }      
    })
  }
})
