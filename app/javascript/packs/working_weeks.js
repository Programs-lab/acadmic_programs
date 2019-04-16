import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
import VueResource from 'vue-resource'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)
Vue.use(VueResource)

document.addEventListener('turbolinks:load', () => {
  var element = document.getElementById('working_week_index')
  if (element != null) {

  var week = JSON.parse(element.dataset.week)
  var pt = JSON.parse(element.dataset.procedureTypes)
  var str = JSON.stringify(week)
  str = str.replace(/\"working_hours\":/g, "\"working_hours_attributes\":")
  week = JSON.parse(str)
  var days = week.working_days
  days.forEach(function(day) { day.working_hours_attributes.forEach(function(hour) {hour._destroy = null})})
  week.working_days = days

  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  var app = new Vue({
    el: '#working_week_index',
    data: {
      week: week,
      procedures: pt
    },

    methods: {
      addHour(id) {
        this.week.working_days[id].working_hours_attributes.push({
          id: null,
          initial_hour: '',
          end_hour: '',
          procedure_type_id: '',
          remember: true,
          _destroy: null
        })
      },
      removeHour(d_id, id) {
        var hour = this.week.working_days[d_id].working_hours_attributes[id]

        if (hour.id == null) {
          this.week.working_days[d_id].working_hours_attributes.splice(id, 1);
        } else {
          this.week.working_days[d_id].working_hours_attributes[id]._destroy = '1'
        }
      },
      undoRemove(d_id, id){
        this.week.working_days[d_id].working_hours_attributes[id]._destroy = null
      },

      saveWeek(){
        var self = this
        this.week.working_days.forEach(function(day){
          self.$http.put("working_days/" + day.id, {working_day: day}).then(response => {
            Turbolinks.visit(window.location)}, response => {console.log(response)
            }) 
          })
        }
      }
    })
  }
})
