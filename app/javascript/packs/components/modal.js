import Vue from 'vue/dist/vue.esm'
import Ripple from 'vue-ripple-directive'
Vue.directive('ripple', Ripple);
Vue.component('modal-vue', {
  props: ['style_button','i'],
  methods: {
    btnModal(){
      this.$parent.modalId(this.i);
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
      return this.$parent.modal2[this.i];
    }
  },
  template: `
  <div class="flex flex-wrap">
    <transition name="transition-modal" >
      <div id="myModal" class="modal" v-show="show" v-cloak>
        <div :class="classAnimatedContent" class="card modal-content" leave-active-class="animated bounceOutRight">
          <div class="row modal-title">
            <div class="flex w-1/2 justify-start">
              <slot name="title"></slot>
            </div>
            <div class="flex w-1/2 justify-end">
              <span class="times" @click="btnModal()">&times;</span>
            </div>
          </div>
          <div class="row my-6">
            <div class="flex w-full justify-start">
              <slot name="content"></slot>
            </div>
          </div>
          <div class="row modal-footer">
            <div class="flex justify-between">
              <button type="button" name="button" class="btn btn-red-light mx-1" @click="btnModal()">Cancelar</button>
              <slot name="footer"></slot>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
  `
})
