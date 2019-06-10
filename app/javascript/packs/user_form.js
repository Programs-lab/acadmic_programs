import Vue from 'vue/dist/vue.esm'
import Vuelidate from 'vuelidate'
import Datepicker from 'vuejs-datepicker';
import VueResource from 'vue-resource'
import TurbolinksAdapter from 'vue-turbolinks';
import {en, es} from 'vuejs-datepicker/dist/locale'
import Multiselect from 'vue-multiselect'
import { required, email, minLength, sameAs } from 'vuelidate/lib/validators';
Vue.use(TurbolinksAdapter)
Vue.use(Vuelidate)
Vue.use(VueResource)
document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('user_form')) {
  var app = new Vue({
    el: '#user_form',
    data: {
      emailValue: document.getElementById("user_form").getAttribute('email'),
      firstNameValue: document.getElementById("user_form").getAttribute('firstName'),
      lastNameValue: document.getElementById("user_form").getAttribute('lastName'),
      birthdateValue: document.getElementById("user_form").getAttribute('birthdate'),      
      roleValue: document.getElementById("user_form").getAttribute('role'),
      en: en,
      es: es,
      modal2: {},
      pre_options: {},
      options: [],
      // options: [
      //   {
      //     language: 'Javascript',
      //     libs: [
      //       { name: 'Vue.js', category: 'Front-end' },
      //       { name: 'Adonis', category: 'Backend' }
      //     ]
      //   },
      //   {
      //     language: 'Ruby',
      //     libs: [
      //       { name: 'Rails', category: 'Backend' },
      //       { name: 'Sinatra', category: 'Backend' }
      //     ]
      //   },
      //   {
      //     language: 'Other',
      //     libs: [
      //       { name: 'Laravel', category: 'Backend' },
      //       { name: 'Phoenix', category: 'Backend' }
      //     ]
      //   }
      // ],
    value: []
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
      isDoctor(roleValue){
        this.role = (roleValue === 'doctor')
      },
      fetchProcedureTypes(){
        var self = this
        self.$http.get(`/api/procedure_types/fetch`).then(response => {self.pre_options = response.body}, response => {console.log(response)})
      },

      assignOptions(){
        console.log(Object.keys(this.pre_options))
        var self = this
        Object.keys(this.pre_options).forEach(function(po_key) {        
          console.log(po_key)
          console.log(self.pre_options[po_key])
          self.options.push(self.pre_options[po_key]) 
        })
      },
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
      },
      modalId(i){
        Vue.set(this.modal2, i , !this.modal2[i]);
      }
    },
    mounted: function() {
      this.disabledButton()
      this.fetchProcedureTypes()
      var self = this
      setTimeout(function(){ 
        self.assignOptions()
      }, 400)
      var multiple_select = document.getElementsByClassName('multiselect__tags')[0]
      multiple_select.classList.remove("multiselect__tags")
      multiple_select.classList.add("field_input")
      multiple_select.classList.add("rounded-t")
      multiple_select.id = "multi-select"
    },
    computed: { 
      disabled: function() {
        return {
          'disabled': this.$v.$anyError || this.$v.$invalid,
          '': !(this.$v.$anyError || this.$v.$invalid),
        }
      }
    },
    components: {
      Datepicker,
      Multiselect
    }
  })
}})
