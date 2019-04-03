import Vue from 'vue/dist/vue.esm'
import vClickOutside from 'v-click-outside'

Vue.component('select-vue', {
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
        'animated slideInDown': this.show,
      }
    },
  },
  template: `
  <div class="flex flex-wrap" style="position: absolute; width: 15%;" v-click-outside="close">
    <button type="button" class="btn btn-secondary w-full bg-white" v-click-outside="close" @click="btnModal">
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
