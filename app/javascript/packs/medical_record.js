import Vue from 'vue/dist/vue.esm'
import vue2Dropzone from 'vue2-dropzone'
import TurbolinksAdapter from 'vue-turbolinks';
import VueMoment from 'vue-moment';
import moment from 'moment';
import VueResource from 'vue-resource'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
import VuePaginate from 'vue-paginate'
import VueEasyTinyMCE from 'vue-easy-tinymce';
import Toasted from 'vue-toasted';
Vue.use(VuePaginate)
Vue.use(TurbolinksAdapter)
Vue.use(VueResource)
Vue.use(VueMoment, { moment } );
moment.locale('es')

document.addEventListener('turbolinks:load', () => {
  Vue.use(Toasted, {iconPack: 'fontawesome', icon : 'check-circle', duration : 2000, position : "top-center", containerClass : "custom-toasted-container", action : {text : "✖️", onClick : (e, toastObject) => {toastObject.goAway(0);}}})
  
  if(document.getElementById('medical_record')) {
    var element = document.getElementById('medical_record')
    var id = element.dataset.medicalRecordId
    var ar = JSON.parse(element.dataset.appointmentReports)
    var str = JSON.stringify(ar)      
    str = str.replace(/\"appointment_report_annotations\":/g, "\"appointment_report_annotations_attributes\":")        
    ar = JSON.parse(str)
    ar.forEach(function(apr){
      apr.appointment_report_annotations_attributes.forEach(function(ann) {
        ann._destroy = null
      }) 
    })
    var an = Array(Object.keys(ar).length).fill(false)  
    var appointment = JSON.parse(document.getElementById("medical_record_form").getAttribute('appointment'))
    var page = (element.dataset.page === 'true');    
    if (JSON.stringify(appointment) == "{}") {
      appointment['id'] = ""
      appointment['appointment_datetime'] = moment().format()
    }
    var app = new Vue({
      el: '#medical_record',
      data: {
        tinyPlugins: ['paste print preview fullpage searchreplace  visualchars fullscreen  table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount'],
        tinyToolbar: 'formatselect | bold italic strikethrough forecolor backcolor permanentpen formatpainter | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent | removeformat',
        tinyToolbar2: '',
        otherOptions: {
          width: '100%',
          height: 104,
          language: 'es_MX',
          menubar: "false"
        },
        postOtherOptions: {
          width: '100%',
          height: 104,
          language: 'es_MX',
          menubar: "false",
          toolbar: "false",          
          readonly: 1,
          forced_root_block: false
        },
        show: false,
        opens: {},
        spinner: false,
        showM: page,
        showC: false,
        showD: false,
        // appointment_reports: ar,
        // showAnontations: an,
        tabItems: {},
        loading: false,
        modal2: {},
        appointment_report_annotations: [],
        appointment: appointment,
        media: [],
        medical_record_id: id,
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
         vueDropzone: vue2Dropzone,
         tinymce: VueEasyTinyMCE
      },

      methods: {
        trigger_open(index){
          Vue.set(this.opens, index, true)
        },

        trigger_close(index){
          Vue.set(this.opens, index, false)
        },

        fetchAnnotations(index){
          var self = this
          self.$http.get("/reportes de citas", {params: {id: self.appointment_reports[index].id, medical_record_id: self.medical_record_id}}).then(response => {
            var annotations = JSON.parse(response.body.appointment_report_annotations)
            annotations.forEach(function(ann) {
              ann._destroy = null
            })   
            self.appointment_reports[index].appointment_report_annotations_attributes = annotations            
            setTimeout(function(){
              self.spinner = false
              Vue.toasted.show('Reporte actualizado')                       
            }, 200)
          }, response => {console.log(response)
          })
        },

        addAnnotaion(apr_id) {        
          this.appointment_reports[apr_id].appointment_report_annotations_attributes.push({
            id: null,
            content: '',
            _destroy: null
          })
        },

        removeAnnotation(appr_id, id) {   
          var annotation = this.appointment_reports[appr_id].appointment_report_annotations_attributes[id]
          if (annotation.id == null) {
            this.appointment_reports[appr_id].appointment_report_annotations_attributes.splice(id, 1);
          }
          else {            
            this.appointment_reports[appr_id].appointment_report_annotations_attributes[id]._destroy = '1';            
          }    
        },

        undoRemove(appr_id, id){          
          this.appointment_reports[appr_id].appointment_report_annotations_attributes[id]._destroy = null;
        },

        saveAnnotations(index){
          var self = this
          var appointment_report_to_update = this.appointment_reports[index]
          self.$http.put(`/reportes de citas/${appointment_report_to_update.id}`, {appointment_report: appointment_report_to_update}).then(response => {
            self.spinner = true
            self.fetchAnnotations(index)            
          }, response => {console.log(response)
          }) 
        },

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
        toggle_annotations(index){
          var element = document.getElementById(`toggle_${index}`)                    
          Vue.set(this.showAnontations, index, !this.showAnontations[index])
          element.classList.toggle("active-button");
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
