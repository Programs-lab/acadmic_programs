import Vue from 'vue/dist/vue.esm'
Vue.component('collapse-vue', {
  props: ['i', 'collapse_type'],
  data: function() {
    return {
       show: false,
       heightC: ''
     };
  },
  methods: {
    close() {
          this.show =! this.show;
    }
  },
  computed: {
    transformClass: function(){
      var collapse_type = this.collapse_type || 'popup'
      var classCollapse = {}
      Vue.set(classCollapse, collapse_type, this.show)
      Vue.set(classCollapse, 'popdown', !this.show)
      return classCollapse
    }
  },
  watch: {
   heightC(){}
  }
  ,
  template: `
  <div :id="i" class="collapse" :class="transformClass">
    <div class="row w-full shadow-md">
      <div class="collapse-title">
        <div class="flex w-full justify-start px-4 items-center" v-on:click="close()">
          <div class="flex w-full justify-start">
            <slot name="title-left"></slot>
          </div>
        </div>
        <div class="flex w-auto justify-end items-center px-4">
          <slot name="title-right"></slot>
        </div>
      </div>
      <div v-show="show" class="collapse-content">
        <slot name="content" ></slot>
      </div>
    </div>
  </div>
  `
})
