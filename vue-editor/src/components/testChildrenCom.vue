<template>
  <div>
    <p>I'm the child component!</p>
    <!-- Content from the parent gets rendered here. -->
    <slot name="children-slot"></slot>
     <v-btn flat color="primary" @click="alertMe">alert</v-btn>
     <v-btn flat color="primary" @click="alertMe2">alert</v-btn>
    <slot></slot>
  </div>
</template>
<script>
const COMPONENT_NAME = 'jx-mobilink-test-child-com'

export default {
  name: COMPONENT_NAME,
  props: {
  },
  created () {
    var vm = this
    vm.$nextTick(function () {
        
    })
  },
  data () {
    return {}
  },
  methods: {
    printMe() {
      console.log('PRINT CHILD COMPONENT')
    },
    alertMe() {
      alert('alert me')
      this.$emit('parentAlertMe')
    },
    alertMe2() {
      this.$emit('parentAlertMe2')
    }
  }
}
</script>