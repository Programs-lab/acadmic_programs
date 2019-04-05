import Vue from 'vue/dist/vue.esm'
import vClickOutside from 'v-click-outside'
import Ripple from 'vue-ripple-directive'
Vue.directive('ripple', Ripple);
Vue.component('dropdown-vue', {
  data: function(){
    return{ show: false }
  },
  methods: {
    btnModal(){
      this.show =! this.show
    },
    close(){
      return this.show = false
    }
  },
  computed: {
    classAnimatedContent: function () {
      return {
        'animated fadeOut': !this.show,
        'animated fadeIn': this.show,
      }
    },
  },
  template: `
  <div class="flex flex-wrap" style="position: absolute; width: 15%;" v-click-outside="close">
    <button type="button" class="btn btn-secondary w-full bg-white" v-ripple = "'rgba(0, 0, 0, 0.10)'" v-click-outside="close" @click="btnModal">
        <slot name="bnt-img"></slot>
        dropdown
    </button>
    <transition>
      <div id="" v-show="show" class="dropdown w-full" :class="classAnimatedContent" style="animation-duration: 0.3s;" v-cloak>
      <slot name="items"></slot>
      </div>
    </transition>
  </div>
  `
})
