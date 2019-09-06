import Vue from 'vue/dist/vue.esm'
import Ripple from 'vue-ripple-directive'
Vue.directive('ripple', Ripple);
Vue.component('modal-vue', {
  props: ['style_button','i','style_modal'],
  data() { return { windowWidth: window.innerWidth } },
  methods: {
    btnModal(){
      this.$root.modalId(this.i);
    }
  },
  computed: {
    classAnimatedContent: function () {
      return {
        'animated slideOutUp': !this.show,
        'animated slideInDown': this.show,
      }
    },
    show: function (){
      return this.$root.modal2[this.i];
    }
  },
  mounted() {
    window.addEventListener('resize', () => {
      this.windowWidth = window.innerWidth
    })
  },
  template: `
  <div class="flex flex-wrap">
    <transition name="transition-modal" >
      <div id="myModal" class="modal" v-show="show" v-cloak>
        <div :class="classAnimatedContent" class="card modal-content flex flex-wrap" leave-active-class="animated bounceOutRight" :style="windowWidth > 640 ? style_modal : 'width: 100%;'">
          <div class="flex w-full modal-title">
            <div class="flex w-1/2 justify-start">
              <slot name="title"></slot>
            </div>
            <div class="flex w-1/2 justify-end">
              <span class="times" @click="btnModal()">&times;</span>
            </div>
          </div>
          <div class="flex w-full my-6">
            <div class="flex w-full justify-start">
              <slot name="content"></slot>
            </div>
          </div>
          <div class="flex flex-wrap w-full modal-footer">

              <slot name="footer"></slot>

          </div>
        </div>
      </div>
    </transition>
  </div>
  `
})
