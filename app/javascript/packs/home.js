import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#home_page',
    data: {
      show: [],
      modal: false
    },
    methods: {
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
    }
  })
})
