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
    computed: {
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
