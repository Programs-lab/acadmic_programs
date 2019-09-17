import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import Ripple from 'vue-ripple-directive'
import { CalendarMixin } from './mixins/calendar_mixin'
Vue.directive('ripple', Ripple);
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('schedule_appointment')) {
  var procedure_type = JSON.parse(document.getElementById("schedule_appointment").getAttribute('procedure_types'))[0]
  var procedure_name = procedure_type != null ? procedure_type.procedure_type_name : ''
  var procedure_duration = procedure_type != null ? procedure_type.procedure_duration : ''
  var procedure_id = procedure_type != null ? procedure_type.id : ''

  var app = new Vue({
    el: '#schedule_appointment',
    mixins: [CalendarMixin],
    data: {
      procedureName: procedure_name,
      procedureDuration: procedure_duration,
      procedureTypeId: procedure_id,
      doctorId: document.getElementById("schedule_appointment").getAttribute('doctor_id'),
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
        var emptyDoctor = this.doctor === undefined
        var emptyWorkingWeek = !emptyDoctor? this.doctor.doctor_working_weeks === undefined : true
        return !emptyDoctor && ! emptyWorkingWeek ? this.indexWeek == this.doctor.doctor_working_weeks.length - 1 : true
      },
      renderForm: function(){
        return this.doctor !== undefined && this.procedureTypeId != ''
      }
    },
    watch: {
     doctorId(){
       this.appointmentHour = ''
       this.fetchData()
     },
     procedureTypeId(){
       this.appointmentHour = ''
       this.fetchData()
     },
     schedule(){},
     idNumber(){
       this.fetchUser()
     }
    }
  })
}})
