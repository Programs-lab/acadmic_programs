import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import Datepicker from 'vuejs-datepicker';
import TurbolinksAdapter from 'vue-turbolinks';
import {en, es} from 'vuejs-datepicker/dist/locale'
import { required, email, minLength, sameAs } from 'vuelidate/lib/validators';
Vue.use(TurbolinksAdapter)
Vue.use(Vuelidate)
document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('sign_up_form')) {
  var app = new Vue({
    el: '#sign_up_form',
    data: {
      emailValue: document.getElementById("sign_up_form").getAttribute('email'),
      firstNameValue: document.getElementById("sign_up_form").getAttribute('firstName'),
      lastNameValue: document.getElementById("sign_up_form").getAttribute('lastName'),
      passwordValue: '',
      passwordConfirmationValue: '',
      birthdateValue: document.getElementById("sign_up_form").getAttribute('birthdate'),
      pato: document.getElementById("sign_up_form").getAttribute('pato'),
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
      }
    },
    components: {
      Datepicker
    }
  })
}})
