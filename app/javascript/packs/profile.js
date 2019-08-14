import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
import Multiselect from 'vue-multiselect'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('user_profile')) {
    var app = new Vue({
      el: '#user_profile',
      data: {
        modal2: {},
        editPassword: false,
        pre_options: {},
        options: [],
        value: JSON.parse(document.getElementById("user_profile").getAttribute('procedure_types')) || [],
        procedure_types: []
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        setProcedureTypes() {
          var array = []
          this.value.forEach(function(val) {
            array.push(val['id'])
          })
          this.procedure_types = array
        },
        assignOptions(){
          var self = this
          Object.keys(this.pre_options).forEach(function(po_key) {
            console.log(po_key)
            console.log(self.pre_options[po_key])
            self.options.push(self.pre_options[po_key])
          })
        },
        fetchProcedureTypes(){
          var self = this
          self.$http.get(`/api/procedure_types/fetch`).then(response => {self.pre_options = response.body}, response => {console.log(response)})
        },
        editField(id){
          var field = document.getElementById(id)
          field.disabled = false
          field.focus()
          if (field.classList.contains('select_flat')) {
            field.classList.remove('select_flat')
          }
          else{
            if(field.type === 'select-one'){
              field.classList.add('select_flat')
            }
          }
        },
        previewAvatar(){
          var input_file = event.target

          if (input_file.files && input_file.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
              $('#avatar').attr('src', e.target.result);
            }
            reader.readAsDataURL(input_file.files[0]);
          }
        }
      },
      mounted: function() {
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

      components: {
        Multiselect
      }
    })
  }
})
