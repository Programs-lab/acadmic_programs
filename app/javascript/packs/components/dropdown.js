import Vue from 'vue/dist/vue.esm'
import vClickOutside from 'v-click-outside'
import Ripple from 'vue-ripple-directive'
Vue.directive('ripple', Ripple);
Vue.component('dropdown-vue', {
  props: ['btn_class','dropdown_style'],
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
  <div class="flex flex-wrap" style="position: relative; width: 15%;" :style="dropdown_style" v-click-outside="close">
    <button type="button" :class="btn_class" class="w-full bg-white" v-ripple = "'rgba(0, 0, 0, 0.10)'" v-click-outside="close" @click="btnModal">
        <slot name="title"></slot>
    </button>
    <transition>
      <div id="" v-show="show" class="dropdown w-full z-10" :class="classAnimatedContent" style="animation-duration: 0.3s; position:absolute;" v-cloak>
      <slot name="items"></slot>
      </div>
    </transition>
  </div>
  `
})
