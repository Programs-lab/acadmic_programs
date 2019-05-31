import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import Datepicker from 'vuejs-datepicker';
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource'
import {en, es} from 'vuejs-datepicker/dist/locale'
import { required, email, minLength, sameAs } from 'vuelidate/lib/validators';
import Ripple from 'vue-ripple-directive'
import { CalendarMixin } from './mixins/calendar_mixin'
Vue.directive('ripple', Ripple);
Vue.use(TurbolinksAdapter)
Vue.use(Vuelidate)
Vue.use(VueResource)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('user_no_registered')) {

  var procedure_type = JSON.parse(document.getElementById("user_no_registered").getAttribute('procedure_types'))[0]
  var procedure_name = procedure_type != null ? procedure_type.procedure_type_name : ''
  var procedure_duration = procedure_type != null ? procedure_type.procedure_duration : ''
  var procedure_id = procedure_type != null ? procedure_type.id : ''

  var app = new Vue({
    el: '#user_no_registered',
    mixins: [CalendarMixin],
    data: {
      emailValue: '',
      firstNameValue: '',
      lastNameValue: '',
      passwordValue: '',
      passwordConfirmationValue: '',
      birthdateValue: document.getElementById("user_no_registered").getAttribute('birthdate'),
      idNumber: '',
      idType: '',
      phoneNumber: '',
      occupation: '',
      address: '',
      company_id: '',
      procedureName: procedure_name,
      procedureDuration: procedure_duration,
      doctorId: document.getElementById("user_no_registered").getAttribute('doctor_id'),
      procedureTypeId: procedure_id,
      scheduleIndexs: [],
      indexNav: 0,
      navIds: [1,2,3],
      currentNav: "",
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
      fetchUser: function(){
        this.$http.get(`/api/appointments/fetch_user/${this.idNumber}/${this.idType}`).then(response => {
          this.patient = response.body[0]
          this.firstNameValue = this.patient != null ? this.patient.first_name : ''
          this.lastNameValue = this.patient != null ? this.patient.last_name : ''
          this.phoneNumber = this.patient != null ? this.patient.phone_number : ''
          this.emailValue = this.patient != null ? this.patient.email : ''
          this.occupation = this.patient != null ? this.patient.occupation : ''
          this.address = this.patient != null ? this.patient.address : ''
          this.birthdateValue = this.patient != null ? this.patient.birthdate : ''
          this.company_id = this.patient != null ? this.patient.company_id : ''
          console.log(this.patient)
        }, response => { console.log(response) });
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
        return this.$v.$anyError || this.$v.$invalid || this.appointmentHour == ''
      },
      disabled: function(){
        return this.doctor != null ? this.indexWeek == this.doctor.doctor_working_weeks.length - 1 : true
      },
      renderForm: function(){
        return this.doctor != null && this.procedureTypeId != ''
      }
    }
    ,
    watch: {
     schedule(){},
     idNumber(){
       if (this.idType != "") {
         this.fetchUser()
       }
     },
     idType(){
       if (this.idNumber != "") {
         this.fetchUser()
       }
     },
     currentNav(){
       this.indexNav = this.navIds.findIndex(n => n == this.currentNav)
     },
     patient(){
       if (this.patient != '' && this.patient != null) {
         this.passwordValue = "123123123"
         this.passwordConfirmationValue = this.passwordValue
         document.getElementById("user_no_registered").setAttribute("action","/appointments/update_appointment")
       }else{
         this.passwordValue = ""
         this.passwordConfirmationValue = this.passwordValue
         document.getElementById("user_no_registered").setAttribute("action","/appointments/create_appointment")
       }
     }
    },
    components: {
      Datepicker
    }
  })
}})
