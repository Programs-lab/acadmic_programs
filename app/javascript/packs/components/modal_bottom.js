import Vue from 'vue/dist/vue.esm'
import Ripple from 'vue-ripple-directive'
import vClickOutside from 'v-click-outside'
Vue.directive('ripple', Ripple);
Vue.component('modal-bottom-vue', {
  props: ['style_button','i'],
  methods: {
    btnModal(){
      this.$root.modalBottomId(this.i);
    },
    close(){
      Vue.set(this.$root.modalBottom, this.i , false)
      return this.$root.modalBottom[this.i];
    }
  },
  computed: {
    classAnimatedContent: function () {
      return {
        'animated slideOutDown': !this.show,
        'animated slideInUp': this.show,
      }
    },
    show: function (){
      return this.$root.modalBottom[this.i];
    }
  },
  template: `
  <div class="flex flex-wrap">
    <transition name="transition-modal-bottom" >
      <div id="myModalBottom" class="modal-bottom" v-show="show" v-cloak>
        <div :class="classAnimatedContent" class="modal-bottom-content flex flex-wrap w-full" v-click-outside="close">
          <div class="flex w-full">
            <div class="flex flex-wrap w-full">
              <slot name="content"></slot>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
  `
})
