import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#companies_index',
    data: {
      show: []
    },
    methods: {
      close(i) {
          var a = document.getElementsByClassName('collapse-content')[i];
          if(a.scrollHeight == 0){
            Vue.set(this.show, i, this.show[i] =! this.show[i]);
            setTimeout(function(){a.style.maxHeight = a.scrollHeight + "px"}, 30)
            document.getElementById(`collapse_${i}`).classList.add('transform_collapse');
          }else{
            a.style.maxHeight = null;
            setTimeout(() => Vue.set(this.show, i, this.show[i] =! this.show[i]), 200)
            document.getElementById(`collapse_${i}`).classList.remove('transform_collapse');
            document.getElementById(`collapse_${i}`).classList.add('transform_collapse_2');
            setTimeout(() => document.getElementById(`collapse_${i}`).classList.remove('transform_collapse_2'), 200)
          }
      },
      close_collapse(i){
          var a = document.getElementsByClassName('collapse-content')[i];
          a.style.maxHeight = null;
          if (this.show[i]) {
            setTimeout(() => Vue.set(this.show, i, this.show[i] = false), 200)
            document.getElementById(`collapse_${i}`).classList.remove('transform_collapse');
            document.getElementById(`collapse_${i}`).classList.add('transform_collapse_2');
            setTimeout(() => document.getElementById(`collapse_${i}`).classList.remove('transform_collapse_2'), 100)
          }
      }
    }
  })
})
