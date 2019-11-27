import Vue from 'vue/dist/vue.esm';
import TurbolinksAdapter from 'vue-turbolinks';
import VueMoment from 'vue-moment';
import moment from 'moment';
import vue2Dropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
import Datepicker from 'vuejs-datepicker';
import VuePaginate from 'vue-paginate'
import VueResource from 'vue-resource';
import vClickOutside from 'v-click-outside';
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)
Vue.use(VuePaginate)
Vue.use(VueMoment, { moment } );

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('program_processes')) {
    var element = document.getElementById('program_processes')
    var ids_arr = JSON.parse(element.dataset.idsArray)
    var testo = JSON.parse(element.dataset.allMedia)
    var media = []
    for (var i in testo) {            
         media.push(testo[i].media)
    }
    var opt_array = []
    var pag = [] 
    var opt = {}
    for (var i in ids_arr) {            
            var opt = {
              url: `/api/media/${ids_arr[i].id}`,
              thumbnailWidth: 230,
              thumbnailHeight: 170,
              maxFilesize: 2,
              addRemoveLinks: true,
              dictDefaultMessage: "<i class='fas fa-cloud-upload-alt'> Subir Archivo</i>",
              headers: { "My-Awesome-Header": "header value" }
            }
            opt_array.push(opt) 
            pag.push(`media_${i}`)
          }
    var app = new Vue({
      el: '#program_processes',
      data: {
        modal2: {},
        men_date: '',
        show_backups: false,
        ids_array: ids_arr,        
        paginate: pag,
        media_array: media,
        options_array: opt_array,
        refresh: false
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        assignOptions(){
          
        },
        fetchAndAssignMedia(){
          var self = this
          var med = []
          for (var i in this.ids_array) {           
           self.$http.get(`/api/media/${this.ids_array[i].id}`).then(response => {Vue.set(this.media_array, i, response.body)}, response => {console.log(response)})
          }          
        },
        removeFilesFromDZ(id){  
          console.log(id)        
          var dz = this.$refs[id]
          setTimeout(function(){
             dz.removeAllFiles()
          }, 1200)
        },
        fetchMedia(id, index) {
          var self = this
          self.$http.get(`/api/media/${id}`).then(response => {Vue.set(self.media_array, index, response.body)}, response => {console.log(response)})
        },
        removeMedium(id, index, j){
          var self = this
          self.$http.delete(`/api/media/${id}`).then(response => {}, response => {console.log(response)})
          console.log(this.media_array)
          this.media_array[index].splice(j, 1);
        }
      },
      mounted: function () {
        this.$nextTick(function () {
          this.assignOptions();
        })
      },
      computed: {

        transformClass: function(){
          return{
            'transform_collapse_2': !this.refresh,
            'transform_collapse': this.refresh,
          }
        },
        animatedClass: function(){
          return{
            'animated slideOutUp': !this.refresh,
            'animated slideInDown': this.refresh,
          }
        }
      },

      components: {
        Datepicker,
        vueDropzone: vue2Dropzone,
      }
    })
  }
})
