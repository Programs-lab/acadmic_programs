import Vue from 'vue/dist/vue.esm'
import vue2Dropzone from 'vue2-dropzone'
import TurbolinksAdapter from 'vue-turbolinks';
import VueMoment from 'vue-moment';
import moment from 'moment';
import VueResource from 'vue-resource'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
import VuePaginate from 'vue-paginate'
Vue.use(VuePaginate)
Vue.use(TurbolinksAdapter)
Vue.use(VueResource)
Vue.use(VueMoment, { moment } );
moment.locale('es')

document.addEventListener('turbolinks:load', () => {  
  if(document.getElementById('medical_record')) {
    var element = document.getElementById('medical_record')
    var id = element.dataset.medicalRecordId
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
        showD: false,
        algo: false,
        tabItems: {},
        modal2: {},
        appointment: appointment,
        media: [],
        paginate: ['media'],
        dropzoneOptions: {
          url: `/api/media/${id}`,
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

        fetchMedia(){
          var self = this 
          self.$http.get(`/api/media/${id}`).then(response => {self.media = response.body}, response => {console.log(response)})
        },

        removeMedium(medium_id, j){
          var self = this 
          self.$http.delete(`/api/media/${medium_id}`).then(response => {}, response => {console.log(response)})
          this.media.splice(j, 1);
        },

        removeFilesFromDZ(){
          var dz = this.$refs.myVueDropzone
          setTimeout(function(){
             dz.removeAllFiles()
          }, 1200)
        },
        showText(){
          this.show =! this.show
        },
        showMedicalRecord(){
          this.showM =! this.showM
          if (this.showD){
            this.showD =! this.showD
          }
        },
        showFileUpload(){
          this.showD =! this.showD
          if(this.showM){
            this.showM =! this.showM
          } 
        }
      },

      mounted: function () {
        this.$nextTick(function () {          
          this.fetchMedia();          
        })
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
