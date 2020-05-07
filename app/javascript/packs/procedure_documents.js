import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vue2Dropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('procedure_documents')) {
    var element = document.getElementById('procedure_documents')
    var ids_arr = JSON.parse(element.dataset.idsArray)
    var proc_id = JSON.parse(element.dataset.procId)
    var docs = JSON.parse(element.dataset.documents)
    var opt_array = []
    for (var i in ids_arr) {
            var opt = {
              url: `/api/procedure_documents/update/${ids_arr[i].id}`,
              thumbnailWidth: 100,
              thumbnailHeight: 100,
              maxFilesize: 2,
              addRemoveLinks: true,
              dictDefaultMessage: "<i class='fas fa-cloud-upload-alt'> Subir Archivo</i>",
              headers: { "My-Awesome-Header": "header value" }
            }
            opt_array.push(opt)
          }
    var app = new Vue({
      el: '#procedure_documents',
      data: {
        ids_array: ids_arr,
        documents: docs,
        options_array: opt_array,
        procedure_id: proc_id,
        modal2: {}
      },
      components: {
        vueDropzone: vue2Dropzone
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        fetchProcedureDocuments(id){
          var self = this
          self.$http.get(`/api/procedure_documents/${id}`).then(response => {self.documents = response.body}, response => {console.log(response)})
        },
        remove_file(id, pr_id){
          var self = this
          self.$http.put(`/api/procedure_documents/remove/${id}`).then(response => {self.fetchProcedureDocuments(pr_id)}, response => {console.log(response)})
        },
        removeFilesFromDZ(id){
          console.log(id)
          var dz = this.$refs[id]
          setTimeout(function(){
             dz.removeAllFiles()
          }, 1200)
        },
      }
    })
  }
})
