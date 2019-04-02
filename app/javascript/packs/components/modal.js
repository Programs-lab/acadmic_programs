import Vue from 'vue/dist/vue.esm'

Vue.component('modal-vue', {
  props: ['style_button'],

  data: function(){
    return{ show: false }
  },
  methods: {
    btnModal(){
      this.show =! this.show
    }
  },
  computed: {
    classAnimatedContent: function () {
      return {
        'animated slideOutUp': !this.show,
        'animated slideInDown': this.show,
      }
    },
  },
  template: `
  <div class="flex flex-wrap">
    <div class="flex w-full">
      <a id="myBtn" :class="style_button" @click="btnModal()">
       <slot name="name_button"></slot>
      </a>
    </div>
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
              <button type="button" name="button" class="btn btn-red-light mx-1"  @click="btnModal()">Cancelar</button>
              <slot name="footer"></slot>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
  `
})
