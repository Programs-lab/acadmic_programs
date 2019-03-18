import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#app',
    data: {
      message: 'Hello Vue!'
    }
  })
})
