import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import Datepicker from 'vuejs-datepicker';
import TurbolinksAdapter from 'vue-turbolinks';
import {en, es} from 'vuejs-datepicker/dist/locale'
import { required, email, minLength, sameAs } from 'vuelidate/lib/validators';
Vue.use(TurbolinksAdapter)
Vue.use(Vuelidate)
document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('user_no_registered')) {
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
      doctor: '',
      idNumber: '',
      idType: '',
      phoneNumber: '',
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
      selectHour: function(){
        var a = event.currentTarget.attributes.id.value
        this.appointmentHour = a
      }
    },
    components: {
      Datepicker
    }
  })
}})
