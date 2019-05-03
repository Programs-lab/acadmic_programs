import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('medical_record')) {
    var app = new Vue({
      el: '#medical_record',
      data: {
        show: false,
        showM: false,
        showC: false,
        algo: false,
        tabItems: {},
        modal2: {},
      },
      methods: {
        modalId(i){
          Vue.set(this.modal2, i , !this.modal2[i]);
        },
        showText(){
          this.show =! this.show
          setTimeout(function () {
            tinyMCE.init({
              selector: 'textarea',
              plugins: 'paste print preview fullpage searchreplace autolink directionality visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern help',
              toolbar: 'fullscreen | formatselect | bold italic strikethrough forecolor backcolor permanentpen formatpainter | link image media pageembed | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent | removeformat | addcomment',
              image_advtab: true,
              paste_data_images: true,
              width: '100%',
              height: 409,
              language: 'es_MX'
            })
          }, 10);
        },
        showMedicalRecord(){
          this.showM =! this.showM
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
