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
      es: es,
      modal: false,
      show: []
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
      },
            close(i) {
          var a = document.getElementsByClassName('element')[i];
          if(a.scrollHeight == 0){
            Vue.set(this.show, i, this.show[i] =! this.show[i]);
            setTimeout(function(){a.style.maxHeight = a.scrollHeight + "px"}, 30)
            document.getElementById(`transform_collapse_${i}`).classList.remove('transform_collapse_2');
            document.getElementById(`transform_collapse_${i}`).classList.add('transform_collapse');
          }else{
            a.style.maxHeight = null;
            setTimeout(() => Vue.set(this.show, i, this.show[i] =! this.show[i]), 200)
            document.getElementById(`transform_collapse_${i}`).classList.remove('transform_collapse');
            document.getElementById(`transform_collapse_${i}`).classList.add('transform_collapse_2');
          }
      },
      btnModal(){
        this.modal =! this.modal
      }
      ,
      closeModal(){
        var modal = document.getElementById('myModal');
        var modal_content = document.getElementsByClassName('modal-content')[0];
        modal.classList.remove('modal-transition')
        setTimeout(function(){
          modal.classList.add('modal')
          modal_content.classList.remove('modal-content-transition')
        }, 30)
      },
      openModal(){
        var modal = document.getElementById('myModal');
        var modal_content = document.getElementsByClassName('modal-content')[0];
        modal.classList.remove('modal')
        setTimeout(function(){
          modal.classList.add('modal-transition')
          modal_content.classList.add('modal-content-transition')
        }, 30)
      }
    },
    mounted: function() {
      this.disabledButton()
    },
    computed: { 
      disabled: function() {
        this.disabledButton()
      },
      classModal: function () {
        return {
          'modal': !this.modal,
          'modal-transition': this.modal,
        }
      },
      classModalContent: function () {
        return {
          'modal-content': !this.modal,
          'modal-content-transition': this.modal,
        }
      },
      classAnimatedContent: function () {
        return {
          'animated slideOutUp': !this.modal,
          'animated slideInDown': this.modal,
        }
      },
    },
    components: {
      Datepicker
    }
  })
}})
