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
      options: JSON.parse(document.getElementById("user_form").getAttribute('academic_departments')),
      other_options: [],
      value: {id: null},
      other_value: {id: null}
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

      setProcedureTypes() {
        var array = []
        this.value.forEach(function(val) {
          array.push(val['id'])
        })
        this.procedure_types = array
      },

      isDoctor(roleValue){
        this.role = (roleValue === 'doctor')
      },
      fetchPrograms(){
        var self = this
        self.$http.get(`/api/academic_programs/fetch_academic_programs/${self.value.id}`).then(response => {self.other_options = response.body}, response => {console.log(response)})
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
      this.$nextTick(function () {  
        var multiple_select = document.getElementsByClassName('multiselect__tags')[0]
        multiple_select.classList.remove("multiselect__tags")
        multiple_select.classList.add("field_input")
        multiple_select.classList.add("rounded-t")
        multiple_select.id = "multi-select"
        var multiple_select = document.getElementsByClassName('multiselect__tags')[0]
        multiple_select.classList.remove("multiselect__tags")
        multiple_select.classList.add("field_input")
        multiple_select.classList.add("rounded-t")
        multiple_select.id = "multi-select"
      })
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
