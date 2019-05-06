import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import Datepicker from 'vuejs-datepicker';
import TurbolinksAdapter from 'vue-turbolinks';
import VueMoment from 'vue-moment';
import VueResource from 'vue-resource'
import moment from 'moment';
import {en, es} from 'vuejs-datepicker/dist/locale'
import { required, email, minLength, sameAs } from 'vuelidate/lib/validators';
import Ripple from 'vue-ripple-directive'
Vue.directive('ripple', Ripple);
Vue.use(TurbolinksAdapter)
Vue.use(Vuelidate)
Vue.use(VueResource)
Vue.use(VueMoment, { moment } );
moment.locale('es')

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('user_no_registered')) {
  var module = require('colombia-holidays');
  var app = new Vue({
    el: '#user_no_registered',
    data: {
      emailValue: '',
      firstNameValue: '',
      lastNameValue: '',
      passwordValue: '',
      passwordConfirmationValue: '',
      birthdateValue: document.getElementById("user_no_registered").getAttribute('birthdate'),
      appointmentHour: '',
      idNumber: '',
      idType: '',
      phoneNumber: '',
      procedureDuration: document.getElementById("user_no_registered").getAttribute('procedure_duration'),
      doctor: "",
      doctorWorkingWeek: '',
      doctorId: document.getElementById("user_no_registered").getAttribute('doctor_id'),
      weekDays: ['Lunes','Martes','Miercoles','Jueves','Viernes'],
      hours: [],
      workingHours: [],
      unavailableWorkingHours: "",
      schedule: [],
      holidays: module.getColombiaHolidaysByYear(2019),
      indexWeek: 0,
      hiddenDropdown: false,
      indexNav: 0,
      navIds: [1,2,3],
      currentNav: "",
      someData: "",
      patient: '',
      en: en,
      es: es
    },

    validations: {
      emailValue: {
        required,
        email
      },
      firstNameValue: {
        required
      },
      lastNameValue: {
        required
      },
      idNumber: {
        required
      },
      idType: {
        required
      },
      passwordValue: {
        required,
        minLength: minLength(8)
      },
      passwordConfirmationValue: {
        sameAsPassword: sameAs('passwordValue')
      }
    },
    methods: {
      fieldClass(element, invalid){
        var el = document.getElementById(element)
        if(invalid){
          el.classList.replace('focus_form', 'invalid_form')
        }
        else {
          el.classList.replace('invalid_form', 'focus_form')
        }
      },
      fetchData: function(){
        this.$http.get(`/api/appointments/${this.doctorId}`).then(response => {
          this.doctor = JSON.parse(response.body.doctor)[0];
          this.unavailableWorkingHours = JSON.parse(response.body.unavailable_working_hours);
          this.doctorWorkingWeek = this.doctor.doctor_working_weeks[this.indexWeek]
          this.matrixWorkingHours()
        }, response => { console.log(response) });
      },
      fetchUser: function(){
        this.$http.get(`/api/appointments/${this.idNumber}/${this.idType}`).then(response => {
          this.patient = response.body[0]
          this.firstNameValue = this.patient.first_name
          this.lastNameValue = this.patient.last_name
          this.phoneNumber = this.patient.phone_number
          this.emailValue = this.patient.email
        }, response => { console.log(response) });
      }
      ,
      selectHour: function(){
        var a = event.currentTarget.attributes.id.value
        this.appointmentHour = a
      },
      selectWorkingHour: function(working_day, hour){
        var arrayHours = []
        var date = working_day.working_date
        var datetime = moment(`${date} ${hour}`)
        if (datetime.isAfter(moment())) {
          var limit_datetime = moment(`${date} ${hour}`).add(1,'hour')
          var wh = working_day.working_hours
          for (var i = 0; i < wh.length; i++) {
            let initial_hour = moment(wh[i].initial_hour)
            let end_hour = moment(wh[i].end_hour)
            if (datetime.isBetween(initial_hour, end_hour, null, '[)')) {
              initial_hour = datetime
              while (initial_hour.isBefore(end_hour) && initial_hour.isBefore(limit_datetime)) {
                if (this.isAvailableHour(initial_hour)) {
                  arrayHours.push(initial_hour.format())
                }
                initial_hour.add(this.procedureDuration,'minutes')
              }
              break;
            }
          }
        }
        return arrayHours;
      },
      isAvailableHour: function(appointment_datetime){
        return this.unavailableWorkingHours.findIndex(d => moment(d.appointment_datetime).isSame(appointment_datetime)) == -1
      },
      isHoliday: function(working_date){
        return this.holidays.findIndex(h => moment(h.holiday).isSame(moment(working_date))) != -1
      }
      ,
      matrixWorkingHours: function(){
        var working_days = this.doctorWorkingWeek.working_days
        if (working_days.length == 0) {
          this.workingHours = Array(5).fill(null).map(()=>Array(this.hours.length).fill([]))
        }
        else {
          for (var i = 0; i < working_days.length; i++) {
            this.workingHours[i] = []
            this.schedule [i] = []
            for (var j = 0; j < this.hours.length; j++) {
              var wh = !this.isHoliday(working_days[i].working_date) ? this.selectWorkingHour(working_days[i], this.hours[j]) : []
              this.workingHours[i][j] = wh
              this.schedule [i][j] = Array(wh.length).fill(false)
            }
          }
        }
      },
      showOptions: function(i, j, k){
        var schedule = this.schedule
        schedule[i][j][k] =! this.schedule[i][j][k]
        Vue.set(this.schedule, i, schedule[i])
      },
      changeNav: function(){
        this.indexNav += 1
        this.currentNav = this.navIds[this.indexNav]
      },
      nextWeek: function(){
        var length = this.doctor.doctor_working_weeks.length
        this.indexWeek += 1
      }
    },
    computed: {
      classArrowLeft: function(){
        var minLimit = this.indexWeek == 0
        return {
          'text-grey-light cursor-not-allowed': minLimit,
          '': !minLimit
        }
      },
      classArrowRight: function(){
        var maxLimit = this.disabled
        return {
          'text-grey-light cursor-not-allowed': maxLimit,
          '': !maxLimit
        }
      },
      validSubmit: function(){
        return this.anyError || this.invalid || this.appointmentHour == ''
      },
      disabled: function(){
        return this.doctor != null ? this.indexWeek == this.doctor.doctor_working_weeks.length - 1 : true
      }
    }
    ,
    watch: {
     doctorId(){
       this.appointmentHour = ''
       this.fetchData()
     },
     schedule(){},
     idNumber(){
       this.fetchUser()
     },
     indexWeek(){
       this.doctorWorkingWeek = this.doctor.doctor_working_weeks[this.indexWeek]
     },
     currentNav(){
       this.indexNav = this.navIds.findIndex(n => n == this.currentNav)
     },
     patient(){
       if (this.patient != '' && this.patient != null) {
         this.passwordValue = "123123123"
         this.passwordConfirmationValue = this.passwordValue
         document.getElementById("user_no_registered").setAttribute("action","/pages/update")
       }else{
         document.getElementById("user_no_registered").setAttribute("action","/pages/create")
       }
     }
    },
    components: {
      Datepicker
    },
    mounted: function () {
      this.$nextTick(function () {
        var hours = []
        var format = ["am","pm"]
        for (var i in format) {
          for (var j = 0; j < 6; j++) {
            let v = 6 + j
            v = (format[i] === "am") ? v : (v - 5)
            hours.push(`${v < 10 ? 0 : ''}${v}:00 ${format[i]}`)
            if (v == 11) {
              hours.push("12:00 pm")
            }
          }
        }
        this.hours = hours
        this.fetchData()
      })
    }
  })
}})
