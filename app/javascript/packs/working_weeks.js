import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
import VueResource from 'vue-resource'
import Datetime from 'vue-datetime'
import Vuelidate from 'vuelidate'
import VueMoment from 'vue-moment'
import moment from 'moment'
import { required, requiredIf } from 'vuelidate/lib/validators';
import 'vue-datetime/dist/vue-datetime.css'
import { Settings } from 'luxon'
import Multiselect from 'vue-multiselect'
Settings.defaultLocale = 'es'
Vue.use(Datetime)
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)
Vue.use(VueResource)
Vue.use(Vuelidate)
Vue.use(VueMoment, {moment})
const after = (params) =>
  (value) => moment(value).isAfter(params)
const before = (params) =>
  (value) => moment(value).isBefore(params)

document.addEventListener('turbolinks:load', () => {
  var element = document.getElementById('working_week_index')
  if (element != null) {


  moment.locale('es')
  var i = parseInt(element.dataset.index) || 0
  var weeks = JSON.parse(element.dataset.weeks)
  var user_id = element.dataset.userId
  var pt = JSON.parse(element.dataset.procedureTypes)
  if (weeks.length === 0) {
    var date = moment()
    var new_week = []
    for (var j = 1; j < 6; j++){
      new_week.push({
        id: null,
        working_date: moment().day(j),
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
      index: i,
      weeks: weeks,
      week: weeks[i],
      last_week: weeks[weeks.length - 1],
      procedures: pt,
      value: [],
      errors: false,
      modal2: {},
      unavailable_working_hours: []
    },


    components: {
      Multiselect
    },

    validations: {
      week: {
        required,
        working_days_attributes: {
          required,
          $each: {
            working_hours_attributes: {
              $each: {
                initial_hour: { 
                    required: requiredIf((working_hours_attribute) => {return working_hours_attribute._destroy !== "1"}),
                    isBefore: (value, working_hours_attribute) => {
                      return moment(value).isSameOrBefore(working_hours_attribute.end_hour) 
                  }
                },
                end_hour: { 
                  required: requiredIf((working_hours_attribute) => {working_hours_attribute._destroy !== "1"}),
                  isBefore: (value, working_hours_attribute) => {
                    return moment(value).isSameOrAfter(working_hours_attribute.initial_hour) 
                  }
                },
                procedure_type_kinds: { required: requiredIf((working_hours_attribute) => {return working_hours_attribute._destroy !== "1"}) }
              }
            }
          }
        }
      }
    },

    methods: {

      modalId(i){
        Vue.set(this.modal2, i , !this.modal2[i]);
      },

      fetch_unavailable_working_hours(id){
        var self = this
        self.$http.get(`api/appointments/horario/working_hours/${id}`).then(response => {self.unavailable_working_hours = response.body}, response => {console.log(response)})
      },

      disabled_working_hour(id){

        if (id != null) {
          return this.unavailable_working_hours.includes(id)
        }
        else{
          return false
        }
        // if(id != null){
        //   var disabled = false        
        //   var self = this
        //   self.$http.get(`api/appointments/horario/working_hours/${id}`).then(response => {
        //     disabled = response.body.disabled
        //     Vue.set(this.booleans, id , disabled)}, response => {console.log(response)})
        //   return this.booleans[id]
        // }
        // else {
        //   return false
        // }

      },

      apply_multiselect_class(){        
        setTimeout(function(){
        var multiple_selects = document.getElementsByClassName('multiselect__tags')        
        for (let multiple_select of multiple_selects) {
          multiple_select.classList.remove("multiselect__tags")
          multiple_select.classList.add("field_input")
          multiple_select.classList.add("rounded-t")
          multiple_select.classList.add("multi-select-padded")
        }}, 0)
      },

      disabled_class_field(id){
        var disabled = this.disabled_working_hour(id)
        if (disabled) {
        setTimeout(function(){ 
          document.getElementById("timepicker_initial_" + id).setAttribute("disabled", "");
          document.getElementById("timepicker_end_" + id).setAttribute("disabled", "");
         }, 100);
        }
        else{
          setTimeout(function(){ 
            document.getElementById("timepicker_initial_" + id).removeAttribute("disabled");
            document.getElementById("timepicker_end_" + id).removeAttribute("disabled");
          }, 100);
        }

        return{
          "disabled_form": disabled,
          "": !disabled
        }
      },  

      disabled_class_button(id){
        var disabled = this.disabled_working_hour(id)
        return{
          "disabled": disabled,
          "": !disabled
        }
      },
      nextWeek(){
        this.index += 1
        this.week = this.weeks[this.index]
      },

      prevWeek(){
        this.index -= 1
        this.week = this.weeks[this.index]
      },

      addHour(id) {
        var week_to_update = (this.modal2["update"] === true) ? this.last_week : this.week
        week_to_update.working_days_attributes[id].working_hours_attributes.push({
          id: null,
          initial_hour: '',
          end_hour: '',
          procedure_type_kinds: [],
          remember: true,
          _destroy: null
        })
      },
      removeHour(d_id, id) {
        var week_to_update = (this.modal2["update"] === true) ? this.last_week : this.week
        var hour = week_to_update.working_days_attributes[d_id].working_hours_attributes[id]

        if (hour.id == null) {
          week_to_update.working_days_attributes[d_id].working_hours_attributes.splice(id, 1);
        } else {
          week_to_update.working_days_attributes[d_id].working_hours_attributes[id]._destroy = '1'
        }
      },
      undoRemove(d_id, id){
        var week_to_update = (this.modal2["update"] === true) ? this.last_week : this.week
        week_to_update.working_days_attributes[d_id].working_hours_attributes[id]._destroy = null
      },

      saveWeek(){
        var week_to_update = (this.modal2["update"] === true) ? this.last_week : this.week
        if (this.$v.week.$invalid) {
          this.errors = true
        }
        else {
        var self = this
        if (week_to_update.id !== null) {
        self.$http.put("horarios/" + week_to_update.id, {working_week: week_to_update}).then(response => {
          Turbolinks.visit(location.origin + location.pathname + "?index=" + self.index)}, response => {console.log(response)
          })
        }
        else {
         self.$http.post("horarios", {working_week: week_to_update}).then(response => {
          Turbolinks.visit(window.location)}, response => {console.log(response)
          }) 
        }
        }  
        }
      },

      mounted: function () {
        this.$nextTick(function () {          
          this.fetch_unavailable_working_hours(user_id);          
          this.apply_multiselect_class();
          this.apply_multiselect_class();
          this.apply_multiselect_class();
        })
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
