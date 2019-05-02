import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
import VueResource from 'vue-resource'
import Datetime from 'vue-datetime'
import Vuelidate from 'vuelidate'
import VueMoment from 'vue-moment'
import moment from 'moment'
import { required } from 'vuelidate/lib/validators';
import 'vue-datetime/dist/vue-datetime.css'
import { Settings } from 'luxon'
Settings.defaultLocale = 'es'
Vue.use(Datetime)
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)
Vue.use(VueResource)
Vue.use(Vuelidate)
Vue.use(VueMoment, {moment})


document.addEventListener('turbolinks:load', () => {
  var element = document.getElementById('working_week_index')
  if (element != null) {


  moment.locale('es')
  var weeks = JSON.parse(element.dataset.weeks)
  var user_id = element.dataset.userId
  var pt = JSON.parse(element.dataset.procedureTypes)
  if (weeks.length === 0) {
    var date = moment()
    var new_week = []
    for (var i = 1; i < 6; i++){
      new_week.push({
        id: null,
        working_date: moment().day(i),
        working_hours: []
      })
    }
    weeks.push({
      id: null,
      doctor_id: user_id,
      initial_date: moment().day(1),
      end_date: moment().day(5),
      working_days: new_week
    })
  }
  var str = JSON.stringify(weeks)
  str = str.replace(/\"working_days\":/g, "\"working_days_attributes\":")
  weeks = JSON.parse(str)
  str = str.replace(/\"working_hours\":/g, "\"working_hours_attributes\":")
  weeks = JSON.parse(str)

  var days = ''

  weeks.forEach(function(week) {
    days = week.working_days_attributes
    days.forEach(function(day) { day.working_hours_attributes.forEach(function(hour) {hour._destroy = null})})
    week.working_days_attributes = days
  })

  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  var app = new Vue({
    el: '#working_week_index',
    data: {
      index: 0,
      weeks: weeks,
      week: weeks[0],
      procedures: pt,
      errors: false
    },

    validations: {
      week: {
        required,
        working_days_attributes: {
          required,
          $each: {
            working_hours_attributes: {
              $each: {
                initial_hour: { required },
                end_hour: { required },
                procedure_type_id: { required }
              }
            }
          }
        }
      }
    },

    methods: {

      nextWeek(){
        this.index += 1
        this.week = this.weeks[this.index]
      },

      prevWeek(){
        this.index -= 1
        this.week = this.weeks[this.index]
      },

      addHour(id) {
        this.week.working_days_attributes[id].working_hours_attributes.push({
          id: null,
          initial_hour: '',
          end_hour: '',
          procedure_type_id: '',
          remember: true,
          _destroy: null
        })
      },
      removeHour(d_id, id) {
        var hour = this.week.working_days_attributes[d_id].working_hours_attributes[id]

        if (hour.id == null) {
          this.week.working_days_attributes[d_id].working_hours_attributes.splice(id, 1);
        } else {
          this.week.working_days_attributes[d_id].working_hours_attributes[id]._destroy = '1'
        }
      },
      undoRemove(d_id, id){
        this.week.working_days_attributes[d_id].working_hours_attributes[id]._destroy = null
      },

      saveWeek(){
        if (this.$v.week.$invalid) {
          this.errors = true
        }
        else {
        var self = this
        if (self.week.id !== null) {
        self.$http.put("horarios/" + self.week.id, {working_week: self.week}).then(response => {
          Turbolinks.visit(window.location)}, response => {console.log(response)
          })
        }
        else {
         self.$http.post("horarios", {working_week: self.week}).then(response => {
          Turbolinks.visit(window.location)}, response => {console.log(response)
          }) 
        }
        }  
        }
      },
      computed: {
        showAlert: function(){
          if (this.errors) {
            this.errors = this.$v.week.$invalid
          }
          return this.errors && this.$v.week.$invalid
        }
      }
    })
  }
})
