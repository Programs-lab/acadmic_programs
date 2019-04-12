import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#medical_record',
    data: {
      show: false,
      tabItems: {}
    },
    methods: {
      showText(){
        this.show =! this.show
        setTimeout(function () {
          tinyMCE.init({
            selector: 'textarea',
            plugins: 'paste print preview fullpage searchreplace autolink directionality visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern help',
            toolbar: 'formatselect | bold italic strikethrough forecolor backcolor permanentpen formatpainter | link image media pageembed | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent | removeformat | addcomment',
            image_advtab: true,
            paste_data_images: true,
            width: '100%',
            height: 409,
            language: 'es'
          })
        }, 10);
      }
    },
    computed: {
      classIconButton: function(){
        return {
          'fa-plus btn-primary': !this.show,
          'fa-trash btn-secondary': this.show
        }
      }
    }
  })
})
