import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks';
import vClickOutside from 'v-click-outside'
Vue.use(TurbolinksAdapter)
Vue.use(vClickOutside)

document.addEventListener('turbolinks:load', () => {
  var app = new Vue({
    el: '#tab',
    data: {
      tabItems: {}
    },
    methods: {
      tabMethod(){
        var nodeOldActive = document.getElementsByClassName('tab-active')[0]
        var keyOldActive = nodeOldActive.attributes.id.value
        var keyNewActive = event.currentTarget.attributes.id.value
        Vue.set(this.tabItems, keyOldActive, false)
        Vue.set(this.tabItems, keyNewActive , true)
        nodeOldActive.classList.remove('tab-active')
        document.getElementById(keyNewActive).classList.add('tab-active')
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        var items = document.getElementsByClassName("tab-item")
        var keyItemActive = items[0].attributes.id.value
        Vue.set(this.tabItems, keyItemActive ,true);
        document.getElementById(keyItemActive).classList.add('tab-active')
      })
    }
  })
})
