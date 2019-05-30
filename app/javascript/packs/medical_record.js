import Vue from 'vue/dist/vue.esm'
import vue2Dropzone from 'vue2-dropzone'
import TurbolinksAdapter from 'vue-turbolinks';
import VueMoment from 'vue-moment';
import moment from 'moment';
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
Vue.use(TurbolinksAdapter)
Vue.use(VueMoment, { moment } );
moment.locale('es')

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('medical_record')) {
    var appointment = JSON.parse(document.getElementById("medical_record_form").getAttribute('appointment'))
    if (JSON.stringify(appointment) == "{}") {
      appointment['id'] = ""
      appointment['appointment_datetime'] = moment().format()
    }
    var app = new Vue({
      el: '#medical_record',
      data: {
        show: false,
        showM: false,
        showC: false,
        algo: false,
        tabItems: {},
        modal2: {},
        appointment: appointment,
        media: [],
        dropzoneOptions: {
          url: '/api/media/2',
          thumbnailWidth: 230,
          thumbnailHeight: 170,
          maxFilesize: 2,
          addRemoveLinks: true,
          dictDefaultMessage: "<i class='fas fa-cloud-upload-alt'> Subir Archivo</i>",
          headers: { "My-Awesome-Header": "header value" }
        }
      },

      components: {
         vueDropzone: vue2Dropzone
      },

      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        showText(){
          this.show =! this.show
        },
        showMedicalRecord(){
          this.showM =! this.showM
        },
        updateMediaArray(){
          this.media = this.$refs.myVueDropzone.getAcceptedFiles()
        }
      },
      computed: {

        classIconButton: function(){
          return {
            'fa-plus btn-primary': !this.show,
            'fa-trash btn-red-light': this.show
          }
        },
        transformClass: function(){
          return{
            'transform_collapse_2': !this.showC,
            'transform_collapse': this.showC,
          }
        },
        animatedClass: function(){
          return{
            'animated slideOutUp': !this.showC,
            'animated slideInDown': this.showC,
          }
        }
      }
    })
  }
})
