<template>
  <div>
    <jx-mobilink-test-child-com ref="childrenCom" @parentAlertMe="alertMe" @parentAlertMe2="alertMe3">
      <p>I'm injected content from the parent!</p>
      <p>I can still bind to data in the parent's scope, like this! {{myVariable}}</p>
      <p slot="children-slot">where are you</p>
    </jx-mobilink-test-child-com>
  </div>
</template>

<script>
import TestChildrenCom from './testChildrenCom.vue';
const COMPONENT_NAME = 'jx-mobilink-test-parent-com'

export default {
  name: COMPONENT_NAME,
  components: {
    TestChildrenCom
  },
  created () {
    var vm = this
    vm.$nextTick(function () {
        var child = vm.$refs.childrenCom
        child.printMe()
    })
  },
  data() {
    return {
      myVariable: `I'm just a lonely old variable.`
    }
  },
  methods: {
    alertMe() {
      alert('parent alert me')
    },
    alertMe3() {
      alert('parent alert me 3')
    }
  }
}
</script>