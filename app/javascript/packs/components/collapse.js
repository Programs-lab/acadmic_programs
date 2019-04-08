import Vue from 'vue/dist/vue.esm'
Vue.component('collapse-vue', {
  props: ['i'],
  data: function() {
    return { show: false };
  },
  methods: {
    close() {
        var a = document.getElementsByClassName('collapse-content').namedItem(this.i);
        if(a.scrollHeight == 0){
          this.show =! this.show;
          setTimeout(function(){a.style.maxHeight = a.scrollHeight + "px"}, 20)
        }else{
          a.style.maxHeight = null;
          setTimeout(() => this.show =! this.show, 150)
        }
    }
  },
  computed: {
    transformClass: function(){
      return{
        'transform_collapse_2': !this.show,
        'transform_collapse': this.show,
      }
    }
  }
  ,
  template: `
  <div class="collapse" :class="transformClass">
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
      <div :id="i" v-show="show" class="collapse-content">
        <slot name="content"></slot>
      </div>
    </div>
  </div>
  `
})
