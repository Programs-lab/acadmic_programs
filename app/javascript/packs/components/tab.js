import Vue from 'vue/dist/vue.esm'
Vue.component('tab-vue', {
  props: ['ids'],
  data: function(){
    return {tabItems: {}, currentTab: ""}
  },
  methods: {
    tabMethod(){
      var keyOldActive = this.currentTab
      var keyNewActive = event.currentTarget.attributes.id.value
      Vue.set(this.tabItems, keyOldActive, false)
      Vue.set(this.tabItems, keyNewActive , true)
      this.currentTab = keyNewActive
    }
  }
  ,
  mounted: function () {
    this.$nextTick(function () {
      this.currentTab = this.ids[0]
      Vue.set(this.tabItems, this.currentTab ,true);
    })
  }
  ,
  template: `
  <div id="tab">
    <ul class="tab">
      <li class="mr-1" v-for="item_id in ids">
        <a :class="tabItems[item_id] ? 'tab-active' : ''" class="tab-item" :id="item_id" @click="tabMethod()">
          <slot :name="item_id"></slot>
        </a>
      </li>
    </ul>
    <div v-for="item_id in ids" v-show="tabItems[item_id]" class="flex py-4">
      <slot :name="'content' + item_id"></slot>
    </div>
  </div>
  `
})
