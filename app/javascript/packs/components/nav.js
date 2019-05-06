import Vue from 'vue/dist/vue.esm'
Vue.component('nav-vue', {
  props: ['ids', 'nav'],
  data: function(){
    return {navItems: {}, currentNav: ""}
  },
  methods: {
    navMethod(){
      var keyOldActive = this.currentNav
      var keyNewActive = event.currentTarget.attributes.id.value
      Vue.set(this.navItems, keyOldActive, false)
      Vue.set(this.navItems, keyNewActive , true)
      this.currentNav = keyNewActive
      this.$root.currentNav = keyNewActive
    }
  },
  watch: {
    nav(){
      var keyOldActive = this.currentNav
      var keyNewActive = this.nav
      Vue.set(this.navItems, keyOldActive, false)
      Vue.set(this.navItems, keyNewActive , true)
      this.currentNav = keyNewActive
    }
  }
  ,
  mounted: function () {
    this.$nextTick(function () {
      this.currentNav = this.nav || this.ids[0]
      Vue.set(this.navItems, this.currentNav ,true);
    })
  }
  ,
  template: `
  <div id="nav">
    <ul class="nav">
      <li class="nav-item" v-for="item_id in ids">
        <a :class="navItems[item_id] ? 'nav-active' : ''" :id="item_id" @click="navMethod()">
          <slot :name="item_id"></slot>
        </a>
      </li>
    </ul>
    <div v-for="item_id in ids" v-show="navItems[item_id]" class="flex py-4">
      <slot :name="'content' + item_id"></slot>
    </div>
  </div>
  `
})
