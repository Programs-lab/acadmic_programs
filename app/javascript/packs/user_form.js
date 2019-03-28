import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import Datepicker from 'vuejs-datepicker';
import TurbolinksAdapter from 'vue-turbolinks';
import {en, es} from 'vuejs-datepicker/dist/locale'
import { required, email, minLength, sameAs } from 'vuelidate/lib/validators';
Vue.use(TurbolinksAdapter)
Vue.use(Vuelidate)
document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('user_form')) {
  var app = new Vue({
    el: '#user_form',
    data: {
      emailValue: document.getElementById("user_form").getAttribute('email'),
      firstNameValue: document.getElementById("user_form").getAttribute('firstName'),
      lastNameValue: document.getElementById("user_form").getAttribute('lastName'),
      birthdateValue: document.getElementById("user_form").getAttribute('birthdate'),
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
      disabledButton(){
        var button = document.getElementById('submit_button') 
        if(this.$v.$anyError || this.$v.$invalid) {
          button.classList.add("disabled")
        }
        else
          button.classList.remove("disabled")
      }
    },
    mounted: function() {
      this.disabledButton()
    },
    computed: { 
      disabled: function() {
        this.disabledButton()
      }
    },
    components: {
      Datepicker
    }
  })
}})
