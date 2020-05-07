import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
import VueResource from 'vue-resource'
import { objectToFormData } from 'object-to-formdata';
import Datetime from 'vue-datetime'
import Vuelidate from 'vuelidate'
import VueMoment from 'vue-moment'
import moment from 'moment'
import { required, requiredIf } from 'vuelidate/lib/validators';
import 'vue-datetime/dist/vue-datetime.css'
import { Settings } from 'luxon'
import Multiselect from 'vue-multiselect'
Settings.defaultLocale = 'es'
Vue.use(Datetime)
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)
Vue.use(VueResource)
Vue.use(Vuelidate)
Vue.use(VueMoment, {moment})
const after = (params) =>
  (value) => moment(value).isAfter(params)
const before = (params) =>
  (value) => moment(value).isBefore(params)

document.addEventListener('turbolinks:load', () => {
  var element = document.getElementById('documents')
  if (element != null) {
  var ac_pr = JSON.parse(element.dataset.process)
  var docs_at = JSON.parse(element.dataset.documentsAttributtes)
  docs_at.forEach(function(doc) {doc._destroy = null})
  ac_pr.documents_attributes = docs_at
  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  var app = new Vue({
    el: '#documents',
    data: {
      ac_process: ac_pr,
      value: [],
      errors: false,
    },

    components: {
      Multiselect
    },

    validations: {
      ac_process: {
        required,
        documents_attributes: {
          required,
          $each: {
            name: {
              required: requiredIf((documents_attribute) => {return documents_attribute._destroy !== "1"})
            },
            description: {
              required: requiredIf((documents_attribute) => {return documents_attribute._destroy !== "1"})
            },
            template: {
              required: requiredIf((documents_attribute) => {return documents_attribute._destroy !== "1"})
            }
          }
        }
      }
    },

    methods: {
      addDocument() {
        this.ac_process.documents_attributes.push({
          id: null,
          name: '',
          description: '',
          template: null,
          _destroy: null
        })
      },

      removeDocument(id) {
        var doc = this.ac_process.documents_attributes[id]
        if (doc.id == null) {
          this.ac_process.documents_attributes.splice(id, 1);
        } else {
          this.ac_process.documents_attributes[id]._destroy = '1'
        }
      },

      undoRemove(id){
        this.ac_process.documents_attributes[id]._destroy = null
      },

      updateDocument(doc, event){
        var input = document.getElementById(event)
        this.ac_process.documents_attributes[doc].template = input.files[0]
      },

      save(){
        if (this.$v.ac_process.$invalid) {
          this.errors = true
        }
        else {

        var options = {
            initialFormData: new FormData(),
            showLeafArrayIndexes: true,
            includeNullValues: true,
        };
        var ap = this.ac_process
        var formData = objectToFormData({academic_process: ap});
        var self = this
        self.$http.put("/procesos/" + this.ac_process.id,  formData, {headers: {
            'Content-Type': 'multipart/form-data'
          }}).then(response => {
          Turbolinks.visit(location.origin + location.pathname)}, response => {console.log(response)
          })
        }
      }
    },

    mounted: function () {
    },

    computed: {
      showAlert: function(){
        if (this.errors) {
          this.errors = this.$v.ac_process.$invalid
        }
        return this.errors && this.$v.ac_process.$invalid
      }
    }
    })
  }
})
