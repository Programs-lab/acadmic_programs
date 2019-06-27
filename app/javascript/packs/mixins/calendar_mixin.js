import Vue from 'vue/dist/vue.esm'
import VueMoment from 'vue-moment';
import VueResource from 'vue-resource'
import moment from 'moment';
Vue.use(VueResource)
Vue.use(VueMoment, { moment } );
moment.locale('es')

var module = require('colombia-holidays');

export const CalendarMixin = {
  data: {
    appointmentHour: '',
    doctor: "",
    doctorWorkingWeek: '',
    weekDays: ['Lunes','Martes','Miercoles','Jueves','Viernes'],
    hours: [],
    workingHours: [],
    unavailableWorkingHours: "",
    schedule: [],
    holidays: module.getColombiaHolidaysByYear(moment().year()),
    indexWeek: 0,
    hiddenDropdown: false,
    week: [],
  },
  methods: {
    fetchData: function(){
      this.$http.get(`/api/appointments/fetch_appointment_data/${this.doctorId}/${this.procedureTypeId}`).then(response => {
        console.log(response.body)
        this.doctor = JSON.parse(response.body.doctor)[0];
        this.unavailableWorkingHours = JSON.parse(response.body.unavailable_working_hours);
        this.procedureDuration = response.body.procedure_type.procedure_duration;        
        this.doctorWorkingWeek = this.doctor !== undefined ? this.doctor.doctor_working_weeks[this.indexWeek] : ""
        this.matrixWorkingHours()
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
      if (datetime.isAfter(moment().add(23, 'hour'))) {
        var limit_datetime = moment(`${date} ${hour}`).add(1,'hour')
        var wh = working_day.working_hours
        for (var i = 0; i < wh.length; i++) {
          let initial_hour = moment(wh[i].initial_hour)
          let end_hour = moment(wh[i].end_hour)
          if (datetime.isBetween(initial_hour, end_hour, null, '[)')) {
            initial_hour = datetime
            while (initial_hour.isBefore(end_hour) && initial_hour.isBefore(limit_datetime)) {
              if (this.isAvailableHour(initial_hour) && initial_hour.isAfter(moment().add(1, 'day'))) {
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
      var working_days = this.doctorWorkingWeek !== '' ? this.doctorWorkingWeek.working_days : []
      if (working_days.length == 0 || !this.renderForm) {
        this.workingHours = Array(5).fill(null).map(()=>Array(this.hours.length).fill([]))
      }
      else {
        this.createWeek()
        for (var i = 0; i < this.week.length; i++) {
          this.workingHours[i] = []
          this.schedule [i] = []
          var wdays = working_days.find(wd => moment(wd.working_date).isSame(this.week[i]))
          for (var j = 0; j < this.hours.length; j++) {
            var wh = []
            if (wdays != null) {
              wh = !this.isHoliday(wdays.working_date) ? this.selectWorkingHour(wdays, this.hours[j]) : []
            }
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
    createWeek: function(){
      for (var i = 0; i < 5; i++) {
        Vue.set(this.week, i, moment(this.doctorWorkingWeek.initial_date).day(i + 1))
      }
    }
  },
  watch: {
   indexWeek(){
     this.doctorWorkingWeek = this.doctor.doctor_working_weeks[this.indexWeek]
     this.matrixWorkingHours()
   }
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
}
