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
      tabMethod(key){
        for (let items in this.tabItems) {
          Vue.set(this.tabItems, items , false);
        }
        Vue.set(this.tabItems, key , true);
      }
    },
    computed: {
      classTabActive: function () {
        return {
          '': !this.modal,
          'tab-active': this.modal,
        }
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        var items = document.getElementsByClassName("tab-item")
        var keyItemActive = items[0].attributes.id.value
        Vue.set(this.tabItems, keyItemActive ,true);
      })
    }
  })
})
